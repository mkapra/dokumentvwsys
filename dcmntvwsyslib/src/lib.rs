#[macro_use]
extern crate diesel;

use diesel::pg::PgConnection;
use diesel::prelude::*;
use diesel::r2d2::{ConnectionManager, PooledConnection};

pub mod database;
mod schema;
pub mod users;

pub type DatabaseConnection = PooledConnection<ConnectionManager<PgConnection>>;

pub fn establish_connection(db_url: &str) -> PgConnection {
    PgConnection::establish(db_url).expect(&format!("Error connecting to {}", db_url))
}
