use log::{debug, error};

fn main()  {
    env_logger::init();

    println!("Hello World!");
    debug!("this is a debug {}", "message");
    error!("this is printed by default");
}
