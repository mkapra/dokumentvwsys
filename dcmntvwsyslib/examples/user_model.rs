use chrono::NaiveDate;
use dcmntvwsyslib::{
    database::Database,
    users::{User, UserRole},
    DatabaseConnection,
};
use diesel::data_types::PgDate;

const DATABASE_URL: &str = "postgres://localhost/dcmntvwsys";

fn create_user(conn: &DatabaseConnection, password: &str) -> i32 {
    let birthdate = NaiveDate::from_ymd(1999, 8, 5).and_hms(0, 0, 1);
    birthdate.timestamp();

    let user = User::create(
        conn,
        "Test",
        "User",
        &PgDate(birthdate.timestamp().try_into().unwrap()),
        password,
        UserRole::User,
    )
    .expect("Could not create user");
    user.id
}

fn print_users(conn: &DatabaseConnection) {
    let users = User::fetch_all(conn);
    println!("Users: {:?}", users);
}

fn main() {
    let db = Database::new(DATABASE_URL);

    let password = User::generate_random_password();
    let created_user_id = create_user(&db.get(), &password);
    let user =
        User::get(&db.get(), created_user_id).expect("Could not fetch user with specific id");
    println!("User: {:?}", user);

    let verified_user = User::check_user(
        &db.get(),
        &format!("{}_{}", user.first_name, user.last_name),
        &password,
    );
    println!("Verified user: {:?}", verified_user);

    print_users(&db.get());
    user.delete(&db.get()).expect("Could not delete user");
    print_users(&db.get());
}
