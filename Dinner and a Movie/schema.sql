-- Recipes
CREATE TABLE recipes (id INTEGER PRIMARY KEY NOT NULL,
            identifier VARCHAR(100) UNIQUE NOT NULL, 
            name VARCHAR(255), 
            url VARCHAR(255),
            image_url VARCHAR(255),
            thumbnail_url VARCHAR(255),
            cuisine VARCHAR(100),
            cost REAL,
            kind VARCHAR(100),
            serves INTEGER,
            yields VARCHAR(25),
            cooking_method VARCHAR(100),
            favorite BOOL);

CREATE TABLE recipe_directions (id INTEGER PRIMARY KEY NOT NULL,
            recipe_id INTEGER NOT NULL,
            step_number INTEGER NOT NULL,
            instruction VARCHAR(500),
            FOREIGN KEY(recipe_id) REFERENCES recipes(id));

CREATE TABLE recipe_ingredients (id INTEGER PRIMARY KEY NOT NULL,
            recipe_id INTEGER NOT NULL,
            identifier VARCHAR(100) NOT NULL,
            name VARCHAR(255),
            preparation VARCHAR(255),
            quantity VARCHAR(100),
            unit VARCHAR(100),
            url VARCHAR(255),
            FOREIGN KEY(recipe_id) REFERENCES recipes(id));

CREATE TABLE recipe_nutritional_information (id INTEGER PRIMARY KEY NOT NULL,
            recipe_id INTEGER NOT NULL,
            calcium VARCHAR(100),
            calories VARCHAR(100),
            calories_fat VARCHAR(100),
            carbohydrates VARCHAR(100),
            cholesterol VARCHAR(100),
            fat VARCHAR(100),
            iron VARCHAR(100),
            protein VARCHAR(100),
            saturated_fat VARCHAR(100),
            sodium VARCHAR(100),
            transFat VARCHAR(100),
            vitamin_A VARCHAR(100),
            vitamin_C VARCHAR(100),
            FOREIGN KEY(recipe_id) REFERENCES recipes(id));

CREATE TABLE scheduled_recipe_events (id INTEGER PRIMARY KEY NOT NULL,
            event_date TIMESTAMP,
            recipe_id INTEGER NOT NULL,
            set_alarm BOOL,
            minutes_before INTEGER,
            FOREIGN KEY(recipe_id) REFERENCES recipes(id));


CREATE TRIGGER on_delete_recipe AFTER DELETE ON recipes BEGIN
            DELETE FROM recipe_directions WHERE recipe_id = old.id;
            DELETE FROM recipe_ingredients WHERE recipe_id = old.id;
            DELETE FROM recipe_nutritional_information WHERE recipe_id = old.id;
            DELETE FROM scheduled_recipe_events WHERE recipe_id = old.id;
END;

-- Restaurants
CREATE TABLE restaurants (id INTEGER PRIMARY KEY NOT NULL,
            identifier VARCHAR(100) UNIQUE NOT NULL,
            name VARCHAR(255),
            url VARCHAR(255),
            image_url VARCHAR(255),
            mobile_url VARCHAR(255),
            rating_url VARCHAR(255),
            phone VARCHAR(20),
            rating VARCHAR(100),
            favorite BOOL);

CREATE TABLE restaurant_locations (id INTEGER PRIMARY KEY NOT NULL,
            restaurant_id INTEGER NOT NULL,
            city VARCHAR(100),
            state VARCHAR(5),
            country VARCHAR(100),
            postal_code VARCHAR(10),
            latitude REAL,
            longitude REAL,
            FOREIGN KEY(restaurant_id) REFERENCES restaurants(id));

CREATE TABLE restaurant_location_addresses (id INTEGER PRIMARY KEY NOT NULL,
            restaurant_location_id INTEGER NOT NULL,
            line_number INTEGER NOT NULL,
            address VARCHAR(255),
            FOREIGN KEY(restaurant_location_id) REFERENCES restaurant_locations(id));

CREATE TABLE restaurant_location_display_addresses (id INTEGER PRIMARY KEY NOT NULL,
            restaurant_location_id INTEGER NOT NULL,
            line_number INTEGER NOT NULL,
            address VARCHAR(255),
            FOREIGN KEY(restaurant_location_id) REFERENCES restaurant_locations(id));

CREATE TABLE scheduled_restaurant_events (id INTEGER PRIMARY KEY NOT NULL,
            event_date TIMESTAMP,
            restaurant_id INTEGER NOT NULL,
            set_alarm BOOL,
            minutes_before INTEGER,
            set_followup BOOL,
            FOREIGN KEY(restaurant_id) REFERENCES restaurants(id));

CREATE TRIGGER on_delete_restaurant AFTER DELETE ON restaurants BEGIN
            DELETE FROM restaurant_locations WHERE restaurant_id = old.id;
            DELETE FROM scheduled_restaurant_events WHERE restaurant_id = old.id;
END;

CREATE TRIGGER on_delete_restaurant_location AFTER DELETE ON restaurant_locations BEGIN
            DELETE FROM restaurant_location_addresses WHERE restaurant_location_id = old.id;
            DELETE FROM restaurant_location_id WHERE restaurant_location_id = old.id;
END;

-- Local Events
CREATE TABLE local_events (id INTEGER PRIMARY KEY NOT NULL,
            identifier VARCHAR(100), 
            title VARCHAR(255), 
            summary VARCHAR(500), 
            url VARCHAR(255));

CREATE TABLE scheduled_local_events (id INTEGER PRIMARY KEY NOT NULL,
            event_date TIMESTAMP,
            local_event_id INTEGER NOT NULL,
            set_alarm BOOL,
            minutes_before INTEGER,
            set_followup BOOL,
            FOREIGN KEY(local_event_id) REFERENCES local_events(id));

CREATE TRIGGER on_delete_local_event AFTER DELETE ON local_events BEGIN
            DELETE FROM scheduled_local_events WHERE local_event_id = old.id;
END;

-- New York Times Events
CREATE TABLE nytimes_events (id INTEGER PRIMARY KEY NOT NULL,
            identifier VARCHAR(100), 
            name VARCHAR(255),
            description VARCHAR(500), 
            address VARCHAR(255), 
            state VARCHAR(5),
            postal_code VARCHAR(10),
            phone VARCHAR(500), 
            event_url VARCHAR(255),
            theater_url VARCHAR(255),
            latitude REAL,
            longitude REAL,
            category VARCHAR(100),
            subcategory VARCHAR(100),
            start_date TIMESTAMP,
            venue VARCHAR(100),
            times_pick BOOL,
            free BOOL,
            kid_friendly BOOL,
            last_chance BOOL,
            festival BOOL,
            long_running BOOL,
            preview BOOL);

CREATE TABLE nytimes_event_days (id INTEGER PRIMARY KEY NOT NULL,
            nytimes_event_id INTEGER NOT NULL,
            day VARCHAR(10),
            FOREIGN KEY(nytimes_event_id) REFERENCES nytimes_events(id));
            
CREATE TABLE scheduled_nytimes_events (id INTEGER PRIMARY KEY NOT NULL,
            event_date TIMESTAMP,
            nytimes_event_id INTEGER NOT NULL,
            set_alarm BOOL,
            minutes_before INTEGER,
            set_followup BOOL,
            FOREIGN KEY(nytimes_event_id) REFERENCES nytimes_events(id));

CREATE TRIGGER on_delete_new_york_times_event AFTER DELETE ON nytimes_events BEGIN
            DELETE FROM nytimes_event_days WHERE nytimes_event_id = old.id;
            DELETE FROM scheduled_nytimes_events WHERE nytimes_event_id = old.id;
END;
