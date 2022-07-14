use anyhow::Result;
use anyhow::{anyhow, Error};
use diesel::data_types::PgDate;
use rand::distributions::Alphanumeric;
use rand::thread_rng;
use rand::Rng;

use super::*;
use schema::users;

const PASSWORD_LENGTH: usize = 8;
const HASH_COST: u32 = 5;

pub enum UserRole {
    Administrator,
    Uploader,
    User,
}

impl Into<i32> for UserRole {
    fn into(self) -> i32 {
        match self {
            UserRole::Administrator => 0,
            UserRole::Uploader => 1,
            UserRole::User => 2,
        }
    }
}

#[derive(Queryable)]
pub struct User {
    pub id: i32,
    pub username: String,
    pub first_name: String,
    pub last_name: String,
    pub birthdate: PgDate,
    pub password: String,
    pub role: i32,
}

#[derive(Insertable)]
#[table_name = "users"]
pub struct NewUser<'a> {
    pub username: &'a str,
    pub first_name: &'a str,
    pub last_name: &'a str,
    pub birthdate: PgDate,
    pub password: &'a str,
    pub role: i32,
}

impl User {
    /// Creates a new user in the database
    ///
    /// # Arguments
    /// `birthdate` - The `PgDate` type is only a wrapper for an integer which represents the seconds elapsed since
    ///     a specific timestamp
    /// `password` - Pass an unhashed password here. The password will be hashed in this function
    ///
    /// # Returns
    /// Returns the new created user or an error that occured. An error can occur while hashing the password or
    /// communicating with the database
    pub fn create(
        conn: &DatabaseConnection,
        first_name: &str,
        last_name: &str,
        birthdate: &PgDate,
        password: &str,
        role: UserRole,
    ) -> Result<Self> {
        let user = NewUser {
            username: &format!("{}_{}", first_name, last_name),
            first_name,
            last_name,
            birthdate: birthdate.to_owned(),
            password: &Self::hash_password(password)?,
            role: role.into(),
        };

        diesel::insert_into(users::table)
            .values(&user)
            .get_result(conn)
            .map_err(|e| Error::from(e).context("Could not create user"))
    }

    /// Returns the user for the given id if found
    pub fn get(conn: &DatabaseConnection, user_id: i32) -> Result<User> {
        use crate::schema::users::dsl::*;
        users.filter(id.eq(user_id)).first(conn).map_err(|e| {
            Error::from(e).context(format!("Could not query user with id {}", user_id))
        })
    }

    /// Returns all the users in the users table
    pub fn fetch_all(conn: &DatabaseConnection) -> Vec<User> {
        use crate::schema::users::dsl::*;
        users
            .load::<Self>(conn)
            .expect("Could not get users from database")
    }

    /// Deletes the user with the given id
    pub fn delete(&self, conn: &DatabaseConnection) -> Result<()> {
        use crate::schema::users::dsl::*;
        let deleted = diesel::delete(users.filter(id.eq(self.id)))
            .execute(conn)
            .map_err(|e| Error::from(e).context("Could not delete user"))?;

        if deleted != 1 {
            return Err(anyhow!("User was not deleted correctly"));
        }

        Ok(())
    }

    /// Generates a random password with alphanumerics. The password has a length of `PASSWORD_LENGTH`
    pub fn generate_random_password() -> String {
        thread_rng()
            .sample_iter(&Alphanumeric)
            .take(PASSWORD_LENGTH)
            .map(char::from)
            .collect()
    }

    /// Checks for a given username and password
    ///
    /// # Returns
    /// If the credentials are verified correctly the user is returned. Otherwise an error is returned.
    pub fn check_user(
        conn: &DatabaseConnection,
        login_username: &str,
        login_password: &str,
    ) -> Result<Self> {
        use crate::schema::users::dsl::*;

        let user = users
            .filter(username.eq(login_username))
            .first::<User>(conn)
            .map_err(|e| Error::from(e).context("Could not get user"))?;

        let verified = bcrypt::verify(login_password, &user.password)
            .map_err(|e| Error::from(e).context("Could not verify password"))?;

        match verified {
            true => Ok(user),
            false => Err(anyhow!("Incorrect username or password"))
        }
    }

    fn hash_password(password: &str) -> Result<String> {
        bcrypt::hash(password, HASH_COST).map_err(|e| Error::from(e).context("Unable to hash the password"))
    }
}
