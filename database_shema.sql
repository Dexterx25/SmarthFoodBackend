CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;




CREATE TABLE type_users(
    id varchar PRIMARY KEY not null,
    name_type_user varchar not null,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON type_users
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();


CREATE SEQUENCE type_users_id_seq OWNED BY type_users.id;
ALTER sequence type_users_id_seq INCREMENT BY 1; 
ALTER TABLE type_users ALTER COLUMN id SET DEFAULT nextval('type_users_id_seq'::regclass);

CREATE INDEX "index_type_users_name_type_user" on type_users(name_type_user);
CREATE INDEX "index_type_users_id" on type_users(id);

INSERT INTO type_users(id, name_type_user) values('1','basic_user');
INSERT INTO type_users(id, name_type_user) values('2','super_user');

CREATE TABLE genders(
  id varchar PRIMARY KEY not null,
  name varchar not null, 
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE TRIGGER genders
BEFORE UPDATE ON genders
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE SEQUENCE genders_id_seq OWNED BY genders.id;
ALTER sequence genders_id_seq INCREMENT BY 1; 
ALTER TABLE genders ALTER COLUMN id SET DEFAULT nextval('genders_id_seq'::regclass);

CREATE INDEX "index_name_on_genders" on genders(name);
CREATE INDEX "index_id_on_genders" on genders(id);

CREATE TABLE users( 
  id varchar PRIMARY KEY not null,
  names varchar not null,
  surnames varchar default '',
  full_name varchar default '',
  gender varchar not null,
  prefix_number varchar,
  type_user_id varchar,
  gender_id varchar,
  active boolean DEFAULT true,
  date_birtday varchar default '',
  height varchar,
  weight varchar,
  email varchar not null,
  count_login varchar default '',
  phone_number varchar,
  avatar varchar default '',
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
      FOREIGN KEY (type_user_id)
          REFERENCES type_users(id)
          ON DELETE CASCADE,
      FOREIGN KEY (gender_id)
          REFERENCES genders(id)
          ON DELETE CASCADE
);


CREATE TRIGGER set_timestamp
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE SEQUENCE users_id_seq OWNED BY users.id;
ALTER sequence users_id_seq INCREMENT BY 1; 
ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);

CREATE INDEX "index_users_on_email" on users(email);
CREATE INDEX "index_users_on_full_name" on users(full_name);
alter table users  add constraint UQ_personas_email  unique (email);
alter table users  add constraint UQ_phone_number  unique (phone_number);


CREATE TABLE authentications(
  id varchar PRIMARY KEY not null,
  user_id varchar,
  encrypted_password varchar not null default '',
  email varchar,
  token varchar DEFAULT '',
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY(user_id)
     REFERENCES users(id)
     ON DELETE CASCADE
);
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON authentications
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE SEQUENCE authentications_id_seq OWNED BY authentications.id;
ALTER sequence authentications_id_seq INCREMENT BY 1; 

ALTER TABLE authentications ALTER COLUMN id SET DEFAULT nextval('authentications_id_seq'::regclass);

CREATE INDEX "index_authentications_users_id" on authentications(user_id);
CREATE INDEX "index_authentications_email" on authentications(email);


CREATE TABLE channelchats(
  id varchar PRIMARY KEY not null,
  channel_name varchar,
  user_id varchar,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMP,
    FOREIGN KEY(user_id)
     REFERENCES users(id)
      ON DELETE CASCADE
);

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON channelchats
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

--CREATE SEQUENCE FOR EVENTS TABLE: 
CREATE SEQUENCE channelchats_id_seq OWNED BY channelchats.id;
ALTER TABLE channelchats ALTER COLUMN id SET DEFAULT nextval('channelchats_id_seq'::regclass);
--Indexings for events Table: 
CREATE INDEX "index_channelchats_on_deleted_at" on channelchats(deleted_at);
CREATE INDEX "index_channelchats_on_user_id" on channelchats(user_id);


CREATE TABLE messages(
  id varchar PRIMARY KEY not null,
  user_id varchar not null,
  message text not null,
  channel_id varchar not null,
  file varchar,
  deleted_at TIMESTAMP,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY(user_id)
      REFERENCES users(id)
       ON DELETE CASCADE,
    FOREIGN KEY(channel_id)
      REFERENCES channelchats(id)
       ON DELETE CASCADE
);

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON messages
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();


--CREATE SEQUENCE FOR EVENTS TABLE: 
CREATE SEQUENCE messages_id_seq OWNED BY messages.id;
ALTER TABLE messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);

CREATE INDEX "index_messages_on_deleted_at" on messages(deleted_at);
CREATE INDEX "index_messages_on_channelchats_id" on messages(channel_id);
CREATE INDEX "index_messages_on_user_id" on messages(user_id);
 
CREATE TABLE category_foods(
  id varchar PRIMARY KEY not null,
  category_name varchar not null,
  picture varchar DEFAULT '',
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TRIGGER category_foods
BEFORE UPDATE ON category_foods
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE SEQUENCE category_foods_id_seq OWNED BY category_foods.id;
ALTER sequence category_foods_id_seq INCREMENT BY 1; 
ALTER TABLE category_foods ALTER COLUMN id SET DEFAULT nextval('category_foods_id_seq'::regclass);

CREATE INDEX "index_category_name_on_category_foods" on category_foods(category_name);
CREATE INDEX "index_id_on_category_foods" on category_foods(id);

CREATE TABLE foods(
  id varchar PRIMARY KEY not null,
  name varchar not null,
  amount varchar DEFAULT '',
  picture varchar DEFAULT '',
  description varchar DEFAULT '',
  url varchar DEFAULT '',
  price varchar DEFAULT '',
  kalories varchar DEFAULT '',
  category_id varchar not null,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY(category_id)
      REFERENCES category_foods(id)
);
CREATE TRIGGER foods
BEFORE UPDATE ON foods
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE SEQUENCE foods_id_seq OWNED BY foods.id;
ALTER sequence foods_id_seq INCREMENT BY 1; 
ALTER TABLE foods ALTER COLUMN id SET DEFAULT nextval('foods_id_seq'::regclass);

CREATE INDEX "index_name_on_foods" on foods(name);
CREATE INDEX "index_id_on_foods" on foods(id);
CREATE INDEX "index_kalorie_on_foods" on foods(kalories);
CREATE INDEX "index_price_on_foods" on foods(price);  



CREATE TABLE age_ranges(
  id varchar PRIMARY KEY not null,
  range_name varchar not null,
  range_init varchar not null, 
  range_finish varchar not null, 
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE TRIGGER age_ranges
BEFORE UPDATE ON age_ranges
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE SEQUENCE age_ranges_id_seq OWNED BY age_ranges.id;
ALTER sequence age_ranges_id_seq INCREMENT BY 1; 
ALTER TABLE age_ranges ALTER COLUMN id SET DEFAULT nextval('age_ranges_id_seq'::regclass);

CREATE INDEX "index_name_on_age_ranges" on age_ranges(range_name);
CREATE INDEX "index_id_on_age_ranges" on age_ranges(id);

CREATE TABLE category_food_component(
  id varchar PRIMARY KEY not null,
  name varchar not null,
  image varchar DEFAULT '',
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TRIGGER category_food_component
BEFORE UPDATE ON category_food_component
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE SEQUENCE category_food_component_id_seq OWNED BY category_food_component.id;
ALTER sequence category_food_component_id_seq INCREMENT BY 1; 
ALTER TABLE category_food_component ALTER COLUMN id SET DEFAULT nextval('category_food_component_id_seq'::regclass);

CREATE INDEX "index_name_on_category_food_component" on category_food_component(name);
CREATE INDEX "index_id_on_category_food_component" on category_food_component(id);
 
 CREATE TABLE food_component(
    id varchar PRIMARY KEY not null,
    name varchar not null,
    skuu varchar,
    description varchar default '',
    kalories varchar DEFAULT '',
    code varchar DEFAULT '',
    gross_weight varchar DEFAULT '',
    useful_weight varchar DEFAULT '',
    net_weight varchar DEFAULT '',
    unit_measure_home varchar default '', 
    age_ranges varchar DEFAULT '',
    image varchar DEFAULT '',
    category_food_component_id  varchar not null,
    age_ranges_id varchar not null,
    category_id varchar not null,
    gender_id varchar not null,
    created_at TIMESTAMP NOT NUll DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY(category_food_component_id)
      REFERENCES category_food_component(id),
    FOREIGN KEY(category_id)
      REFERENCES category_foods(id),
    FOREIGN KEY (age_ranges_id)
      REFERENCES age_ranges(id),
    FOREIGN KEY (gender_id)
      REFERENCES genders(id)
  );
  CREATE TRIGGER food_component
  BEFORE UPDATE ON food_component
  FOR EACH ROW
  EXECUTE PROCEDURE trigger_set_timestamp();

  CREATE SEQUENCE food_component_id_seq OWNED BY food_component.id;
  ALTER sequence food_component_id_seq INCREMENT BY 1; 
  ALTER TABLE food_component ALTER COLUMN id SET DEFAULT nextval('food_component_id_seq'::regclass);

  CREATE INDEX "index_name_on_food_component" on food_component(name);
  CREATE INDEX "index_id_on_food_component" on food_component(id);
  CREATE INDEX "index_kalorie_on_food_component" on food_component(kalories);
  CREATE INDEX "index_gross_weight_on_food_component" on food_component(gross_weight);
  CREATE INDEX "index_useful_weight_on_food_component" on food_component(useful_weight);
  CREATE INDEX "index_unit_measure_home_on_food_component" on food_component(unit_measure_home, age_ranges);
  CREATE INDEX "index_net_weight_on_food_component" on food_component(net_weight);

CREATE TABLE family_members(
   id varchar PRIMARY KEY not null,
   gender_id varchar not null,
   date_birtday varchar not null,
   parent varchar not null,
   user_id varchar not null,
   created_at TIMESTAMP NOT NULL DEFAULT NOW(),
   updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
   FOREIGN KEY(user_id)
    REFERENCES users(id),
   FOREIGN KEY (gender_id)
    REFERENCES genders(id)
);
CREATE TRIGGER family_members
BEFORE UPDATE ON family_members
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE SEQUENCE family_members_id_seq OWNED BY family_members.id;
ALTER sequence family_members_id_seq INCREMENT BY 1; 
ALTER TABLE family_members ALTER COLUMN id SET DEFAULT nextval('family_members_id_seq'::regclass);


CREATE TABLE foods_market(
  id varchar PRIMARY KEY not null,
  name varchar default '',
  user_id varchar not null,
  picture varchar DEFAULT '',
  food_id varchar not null,
  family_member_id varchar not null,
  times_recurral_market varchar not null,
  date_init varchar default '',
  date_finish varchar default '',
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY (user_id)
    REFERENCES users(id),
  FOREIGN KEY (food_id)
    REFERENCES foods(id),
  FOREIGN KEY (family_member_id)
    REFERENCES family_members(id)
);

CREATE TRIGGER foods_market
BEFORE UPDATE ON foods_market
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE SEQUENCE foods_market_id_seq OWNED BY foods_market.id;
ALTER sequence foods_market_id_seq INCREMENT BY 1; 
ALTER TABLE foods_market ALTER COLUMN id SET DEFAULT nextval('foods_market_id_seq'::regclass);

CREATE INDEX "index_name_on_foods_market" on foods_market(name);
CREATE INDEX "index_id_on_foods_market" on foods_market(id);


CREATE TABLE foods_component_market(
  id varchar PRIMARY KEY not null,
  food_market_id varchar not null,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY (food_market_id)
    REFERENCES foods_market(id)
);

CREATE TRIGGER foods_component_market
BEFORE UPDATE ON foods_component_market
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE SEQUENCE foods_component_market_id_seq OWNED BY foods_component_market.id;
ALTER sequence foods_component_market_id_seq INCREMENT BY 1; 
ALTER TABLE foods_component_market ALTER COLUMN id SET DEFAULT nextval('foods_component_market_id_seq'::regclass);

CREATE INDEX "index_id_on_foods_component_market" on foods_component_market(id);
CREATE INDEX "index_id_on_foods_market_id" on foods_component_market(food_market_id);



CREATE TABLE history_foods_market(
  id varchar PRIMARY KEY not null,
  name varchar not null,
  user_id varchar not null,
  total_amount varchar not null,
  picture varchar DEFAULT '',
  total_kalories varchar not null,
  foods_saved varchar  not null,
  markets varchar not null,
  date_time_init TIMESTAMP not null,
  date_time_finish TIMESTAMP not null,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
   FOREIGN KEY (user_id)
    REFERENCES users(id)
);

CREATE TRIGGER history_foods_market
BEFORE UPDATE ON history_foods_market
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE SEQUENCE history_foods_market_id_seq OWNED BY history_foods_market.id;
ALTER sequence history_foods_market_id_seq INCREMENT BY 1; 
ALTER TABLE history_foods_market ALTER COLUMN id SET DEFAULT nextval('history_foods_market_id_seq'::regclass);

CREATE INDEX "index_name_on_history_foods_market" on history_foods_market(name);
CREATE INDEX "index_id_on_history_foods_market" on history_foods_market(id);
CREATE INDEX "index_total_kalories_on_history_foods_market" on history_foods_market(total_kalories);
CREATE INDEX "index_total_amount_on_history_foods_market" on history_foods_market(total_amount);

CREATE TABLE family_user_market(
  id varchar PRIMARY KEY not null,
  user_id varchar not null,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY (user_id)
    REFERENCES users (id)
);

CREATE TRIGGER family_user_market
BEFORE UPDATE ON family_user_market
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE SEQUENCE family_user_market_id_seq OWNED BY family_user_market.id;
ALTER sequence family_user_market_id_seq INCREMENT BY 1; 
ALTER TABLE family_user_market ALTER COLUMN id SET DEFAULT nextval('family_user_market_id_seq'::regclass);

CREATE TABLE polls_type(
  id varchar PRIMARY KEY not null,
  name varchar not null,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE TRIGGER polls_type
BEFORE UPDATE ON polls_type
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE SEQUENCE polls_type_id_seq OWNED BY polls_type.id;
ALTER sequence polls_type_id_seq INCREMENT BY 1; 
ALTER TABLE polls_type ALTER COLUMN id SET DEFAULT nextval('polls_type_id_seq'::regclass);

insert into polls_type(id, name) values('1', 'initial_market_poll');

CREATE TABLE polls(
  id varchar PRIMARY KEY not null,
  times_recurral_market varchar not null,
  count_persons varchar not null,
  sugest_snaks boolean default false,
  user_id varchar not null,
  type_id varchar not null,
  sugest_without_dairy boolean default false,
  vegetarian_food boolean default false,
   created_at TIMESTAMP NOT NULL DEFAULT NOW(),
   updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (user_id)
      REFERENCES users(id),
    FOREIGN KEY (type_id)
      REFERENCES polls_type(id)
);
CREATE TRIGGER polls
BEFORE UPDATE ON polls
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE SEQUENCE polls_id_seq OWNED BY polls.id;
ALTER sequence polls_id_seq INCREMENT BY 1; 
ALTER TABLE polls ALTER COLUMN id SET DEFAULT nextval('polls_id_seq'::regclass);

INSERT into  category_food_component(id, name) values('1', 'Cereal'), ('2', 'Raices'), ('3', 'Tuberculos'), ('4', 'Platanos'), ('5','Frutas'), ('6', 'Leche y Productos Lacteos'), ('7', 'Carne'), ('8','Huevos'), ('9', 'Frutos Secos y Semillas'), ('10', 'Grasas'), ('11','Azucares'), ('12', 'Leguminosas'), ('13', 'Verduras');
INSERT INTO age_ranges(id, range_name, range_init, range_finish) values('1','2-5','2', '5'), ('2','6-9', '6', '9'), ('3','10-13','10', '13'), ('4', '14-17', '14', '17'), ('5', '18-59', '18', '59');

INSERT INTO category_foods (id, category_name) values ('1' ,'Breakfast');
INSERT INTO category_foods (id, category_name) values ('2' ,'Lunch');
INSERT INTO category_foods (id, category_name) values ('3' ,'Snack');
INSERT INTO category_foods (id, category_name) values ('4' ,'Dinner');

INSERT INTO genders(id, name) values('1', 'Male'), ('2', 'Female');


INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','1','Pan blanco','A060','44','100','44','1 tajada delgada', '5', '2', 'Pan blanco_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','1','Harina de trigo refinada fortificada','A040','50','100','50','4 cucharadas soperas rasas', '5', '2', 'Harina de trigo refinada fortificada_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','1','Harina de maíz blanco trillado','A034','50','100','50','2 cucharadas soperas rasas', '5', '2', 'Harina de maíz blanco trillado_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','1','Arepa delgada de maíz blanco trillado','A006','112','100','112','1 unidad pequeña', '5', '2', 'Arepa delgada de maíz blanco trillado_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','1','Avena en hojuelas','A012','48','100','48','4 cucharadas soperas colmadas', '5', '2', 'Avena en hojuelas_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','2','Arracacha sin cáscara cruda','B015','192','80','153,6','1 trozo pequeño', '5', '2', 'Arracacha sin cáscara cruda_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','2','Ñame sin cáscara cocido','P073','156','100','156','1 trozo pequeño', '5', '2', 'Ñame sin cáscara cocido_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','2','Yuca blanca cruda','B107','124','80','99,2','1 trozo mediano', '5', '2', 'Yuca blanca cruda_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','3','Papa común cocida','B073','166','100','166','1 unidad mediana', '5', '2', 'Papa común cocida_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','3','Papa criolla cocida','B070','216','100','216','3 unidades medianas', '5', '2', 'Papa criolla cocida_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','4','Plátano verde sin cáscara','B091','156','100','156','1/2 unidad mediana', '5', '2', 'Plátano verde sin cáscara_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','4','Plátano colí o guineo crudo','B084','176','60','105,6','1 unidad mediana', '5', '2', 'Plátano colí o guineo crudo_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','4','Plátano hartón maduro sin cáscara cocido','B088','132','100','132','1/4 unidad mediana', '5', '2', 'Plátano hartón maduro sin cáscara cocido_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','5','Banano común','C010','65','70','45,5','1/2 unidad grande', '5', '2', 'Banano común_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','5','Fresas','C025','161','95','152,95','9 unidades medianas', '5', '2', 'Fresas_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','5','Granadilla','C028','218','30','65,4','1 unidad grande', '5', '2', 'Granadilla_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','5','Guanábana','C030','200','70','140','4 cucharadas soperas colmadas', '5', '2', 'Guanábana_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','5','Guayaba común','C031','200','75','150','1 unidad grande', '5', '2', 'Guayaba común_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','5','Kiwi','C042','164','91','149,24','1 unidad mediana', '5', '2', 'Kiwi_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','5','Mandarina','C050','210','70','147','1 unidad mediana', '5', '2', 'Mandarina_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','5','Mango','C051','224','50','112','1 unidad pequeña', '5', '2', 'Mango_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','5','Manzana','C054','224','85','190,4','1 unidad pequeña', '5', '2', 'Manzana_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','5','Maracuyá','C056','194','32','62,08','2 unidades medianas', '5', '2', 'Maracuyá_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','5','Melón','C060','252','50','126','1 tajada delgada', '5', '2', 'Melón_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','5','Moras de castilla','C061','432','90','388,8','38 unidades', '5', '2', 'Moras de castilla_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','5','Naranja','C062','294','60','176,4','1 unidad pequeña', '5', '2', 'Naranja_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','5','Papaya','C065','256','70','179,2','1 trozo mediano', '5', '2', 'Papaya_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','5','Pera','C071','266','85','226,1','1/2 unidad mediana', '5', '2', 'Pera_woman_1_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','5','Piña','C072','230','55','126,5','1 tajada delgada', '5', '2', 'Piña_woman_1_18-59  ' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','5','Tomate de árbol','C082','344','86','295,84','2 unidades medianas', '5', '2', 'Tomate de árbol_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','5','Uchuvas','C084','138','94','129,72','13 unidades medianas', '5', '2', 'Uchuvas_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','6','Leche de vaca en polvo entera','G008','54','100','54','6 cucharadas soperas rasas', '5', '2', 'Leche de vaca en polvo entera_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','6','Leche de vaca líquida entera pasterizada','G012','400','100','400','1 vaso mediano', '5', '2', 'Leche de vaca líquida entera pasterizada_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','6','Kumis, entero, con azúcar','G002','300','100','300','1 vaso pequeño', '5', '2', 'Kumis, entero, con azúcar_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','6','yogurt, bebible, entero, con azúcar','G028','300','100','300','1 vaso pequeño', '5', '2', 'yogurt, bebible, entero, con azúcar' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','6','Queso campesino','G017','40','100','40','1 tajada pequeña delgada', '5', '2', 'Queso campesino_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','6','Queso mozzarella de leche entera','G019','56','100','56','1 tajada semigruesa', '5', '2', 'Queso mozzarella de leche entera_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','6','Leche baja en grasa','G007','400','100','400','1 vaso mediano', '5', '2', 'Leche baja en grasa_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','6','Yogur dietético','N005','400','100','400','1 vaso mediano', '5', '2', 'Yogur dietético_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','7','Atún enlatado en aceite','E003','80','100','80','1/3 lata mediana', '5', '2', 'Atún enlatado en aceite_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','7','Carne de cerdo','F011','120','100','120','1/8 de libra', '5', '2', 'Carne de cerdo_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','7','Carne de res','F099','120','100','120','1/8 de libra', '5', '2', 'Carne de res_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','8','Huevo de gallina crudo','J004','100','90','90','1 unidad pequeña', '5', '2', 'Huevo de gallina crudo_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','9','Nuez del Brasil','C064','16','100','16','2 unidades medianas', '5', '2', 'Nuez del Brasil_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','9','Marañón tostado sin sal','C059','20','100','20','1 cucharada sopera colmada', '5', '2', 'Marañón tostado sin sal_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','9','Maní crudo con cáscara','T028','28','100','28','1 cucharada sopera colmada', '5', '2', 'Maní crudo con cáscara_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','9','Maní sin sal','T029','20','98','19,6','1 cucharada sopera colmada', '5', '2', 'Maní sin sal_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','9','Macadamia tostada sin sal','C046','12','100','12','3 unidades medianas', '5', '2', 'Macadamia tostada sin sal_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','9','Coco deshidratado','C020','18','100','18','1 cucharadas soperas colmadas', '5', '2', 'Coco deshidratado_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','9','Coco fresco rallado','C019','28','45','12,6','2 cucharadas sopera colmadas', '5', '2', 'Coco fresco rallado_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','10','Aceite de girasol','D004','7,5','100','7,5','1 cucharadita', '5', '2', 'Aceite de girasol' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','10','Aceite de maíz','D006','7,5','100','7,5','1 cucharadita', '5', '2', 'Aceite de maíz_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','10','Aceite de soya','D012','7,5','100','7,5','1 cucharadita', '5', '2', 'Aceite de soya_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','10','Aceite de ajonjolí','D001','7,5','100','7,5','1 cucharadita', '5', '2', 'Aceite de ajonjolí_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','10','Mayonesa comercial','D020','9','100','9','1 cucharadita dulcera rasa', '5', '2', 'Mayonesa comercial_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','10','Aceite de oliva','D008','7,5','100','7,5','1 cucharadita', '5', '2', 'Aceite de oliva_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','10','Aceite de canola','D003','7,5','100','7,5','1 cucharadita', '5', '2', 'Aceite de canola_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','10','Aguacate','C002','45','77','34,65','1/8 unidad', '5', '2', 'Aguacate_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','10','Margarinas suaves promedio','D019','7,5','100','7,5','1 cucharadita dulcera', '5', '2', 'Margarinas suaves promedio_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','10','Crema de leche líquida entera','G001','21','100','21','1 cucharada sopera alta', '5', '2', 'Crema de leche líquida entera_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','10','Tocineta','F022','10,5','100','10,5','1 tira', '5', '2', 'Tocineta_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','10','Queso crema','G014','19,5','100','19,5','1 cucharadita dulcera colmada', '5', '2', 'Queso crema_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','10','Mantequilla','D015','9','100','9','1 cucharadita dulcera rasa', '5', '2', 'Mantequilla_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','10','Aceite de palma','D009','7,5','100','7,5','1 cucharadita', '5', '2', 'Aceite de palma_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','10','Manteca de cerdo','D014','6','100','6','1 cucharadita dulcera', '5', '2', 'Manteca de cerdo_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','11','Azúcar granulada','K003','23','100','23','2 cucharadas soperas colmadas', '5', '2', 'Azúcar granulada_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','11','Miel de abejas','K031','21','100','21','1 cucharada sopera', '5', '2', 'Miel de abejas_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('1','11','Panela','K033','29','100','29','1 trozo pequeño', '5', '2', 'Panela_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','1','Pan blanco','A060','44','100','44','1 tajada delgada', '5', '2', 'Pan blanco_1_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','1','Harina de trigo refinada fortificada','A040','50','100','50','4 cucharadas soperas rasas', '5', '2', 'Harina de trigo refinada fortificada_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','1','Harina de maíz blanco trillado','A034','50','100','50','2 cucharadas soperas rasas', '5', '2', 'Harina de maíz blanco trillado_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','1','Arepa delgada de maíz blanco trillado','A006','112','100','112','1 unidad pequeña', '5', '2', 'Arepa delgada de maíz blanco trillado_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','1','Pasta larga, cocida','A073','128','100','128','2/3 de pocillo chocolatero', '5', '2', 'Pasta larga, cocida_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','1','Arroz blanco, cocido','A009','160','100','160','6 cucharadas soperas colmadas', '5', '2', 'Arroz blanco, cocido_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','1','Arroz integral, cocido','A011','162','100','162','8 cucharadas soperas colmadas o 2/3 de pocillo', '5', '2', 'Arroz integral, cocido_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','2','Arracacha sin cáscara cruda','B015','192','80','153,6','1 trozo pequeño', '5', '2', 'Arracacha sin cáscara cruda_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','2','Ñame sin cáscara cocido','P073','156','100','156','1 trozo pequeño', '5', '2', 'Ñame sin cáscara cocido_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','2','Yuca blanca cruda','B107','124','80','99,2','1 trozo mediano', '5', '2', 'Yuca blanca cruda_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','3','Papa común cocida','B073','166','100','166','1 unidad mediana', '5', '2', 'Papa común cocida_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','3','Batata cocida sin cáscara','B021','200','80','160','1 trozo pequeño', '5', '2', 'Batata cocida sin cáscara_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','3','Papa criolla cocida','B070','216','100','216','3 unidades medianas', '5', '2', 'Papa criolla cocida_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','4','Plátano verde sin cáscara','B091','156','100','156','1/2 unidad mediana', '5', '2', 'Plátano verde sin cáscara_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','4','Plátano colí o guineo crudo','B084','176','60','105,6','1 unidad mediana', '5', '2', 'Plátano colí o guineo crudo_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','4','Plátano hartón maduro sin cáscara cocido','B088','132','100','132','1/4 unidad mediana', '5', '2', 'Plátano hartón maduro sin cáscara cocido_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','5','Arveja verde','B019','42','40','16,8','3 cucharadas soperas', '5', '2', 'Arveja verde_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','5','Ahuyama o Zapallo','B006','68','85','57,8','1 trozo mediano', '5', '2', 'Ahuyama o Zapallo_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','5','Cebolla puerro','B030','50','95','47,5','1 tallo grueso', '5', '2', 'Cebolla puerro_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','5','Cebolla cabezona','B027','50','95','47,5','6 rodajas delgadas', '5', '2', 'Cebolla cabezona_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','5','Champiñones','B033','93','100','93','1/2 pocillo chocolatero', '5', '2', 'Champiñones_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','5','Coliflor','B039','86','80','68,8','3 gajos pequeños', '5', '2', 'Coliflor_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','5','Pimentón rojo','B080','88','85','74,8','1/2 unidad mediana', '5', '2', 'Pimentón rojo_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','5','Remolacha','B098','57','80','45,6','1/2 unidad pequeña', '5', '2', 'Remolacha_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','5','Repollo morado','B101','120','85','102','2 pocillos chocolateros', '5', '2', 'Repollo morado_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','5','Tomate rojo','B103','126','80','100,8','1 unidad grande', '5', '2', 'Tomate rojo_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','5','Zanahoria','B110','58','85','49,3','1/2 pocillo chocolatero', '5', '2', 'Zanahoria_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','5','Champiñones enlatados','B034','83','100','83','1/2 pocillo chocolatero', '5', '2', 'Champiñones enlatados_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','5','Espárragos enlatados','B041','105','100','105','19 tallos delgados', '5', '2', 'Espárragos enlatados_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','5','Habichuelas enlatadas','B051','100','100','100','3/4 pocillo (cuadros)', '5', '2', 'Habichuelas enlatadas_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','6','Banano común','C010','65','70','45,5','1/2 unidad grande', '5', '2', 'Banano común_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','6','Fresas','C025','161','95','152,95','9 unidades medianas', '5', '2', 'Fresas_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','6','Granadilla','C028','109','30','32,7','1 unidad grande', '5', '2', 'Granadilla_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','6','Guanábana','C030','100','70','70','4 cucharadas soperas colmadas', '5', '2', 'Guanábana_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','6','Guayaba común','C031','100','75','75','1 unidad grande', '5', '2', 'Guayaba común_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','6','Kiwi','C042','82','91','74,62','1 unidad mediana', '5', '2', 'Kiwi_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','6','Mandarina','C050','105','70','73,5','1 unidad mediana', '5', '2', 'Mandarina_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','6','Mango','C051','112','50','56','1 unidad pequeña', '5', '2', 'Mango_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','6','Manzana','C054','112','85','95,2','1 unidad pequeña', '5', '2', 'Manzana_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','6','Maracuyá','C056','97','32','31,04','2 unidades medianas', '5', '2', 'Maracuyá_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','6','Melón','C060','126','50','63','1 tajada delgada', '5', '2', 'Melón_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','6','Moras de castilla','C061','216','90','194,4','38 unidades', '5', '2', 'Moras de castilla_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','6','Naranja','C062','147','60','88,2','1 unidad pequeña', '5', '2', 'Naranja_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','6','Papaya','C065','128','70','89,6','1 trozo mediano', '5', '2', 'Papaya_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','6','Pera','C071','133','85','113,05','1/2 unidad mediana', '5', '2', 'Pera_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','6','Piña','C072','115','55','63,25','1 tajada delgada', '5', '2', 'Piña_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','6','Tomate de árbol','C082','172','86','147,92','2 unidades medianas', '5', '2', 'Tomate de árbol_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','6','Uchuvas','C084','69','94','64,86','13 unidades medianas', '5', '2', 'Uchuvas_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','12','Frijol cargamanto rosado con plátano verde*','T012','58,8','100','58,8','1/2 cucharón', '5', '2', 'Frijol cargamanto rosado con plátano verde_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','12','Frijol bola roja con plátano verde*','T006','65','100','65','1/2 cucharón', '5', '2', 'Frijol bola roja con plátano verde_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','12','Frijol nima con guiso**','T015','70','100','70','1/2 cucharón', '5', '2', 'Frijol nima con guiso_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','12','Frijol caraota con guiso**','T009','70','100','70','1/2 cucharón', '5', '2', 'Frijol caraota con guiso**_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','12','Frijol cabecita negra con guiso**','T007','70','100','70','1/2 cucharón', '5', '2', 'Frijol cabecita negra con guiso**_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','12','Garbanzo con guiso**','T019','49','100','49','1/2 cucharón', '5', '2', 'Garbanzo con guiso_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','12','Soya con guiso**','T030','39','100','39','1/2 cucharón', '5', '2', 'Soya con guiso_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','12','Lenteja con guiso**','T026','54,6','100','54,6','1/2 cucharón', '5', '2', 'Lenteja con guiso_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Bagre carne y piel','E008','175','92','161','1/3 de filete pequeño', '5', '2', 'Bagre carne y piel_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Carne de ternera','F131','150','100','150','1/8 de libra', '5', '2', 'Carne de ternera_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Contramuslo carne sin piel cruda sin hueso','F075','150','91','136,5','1 unidad mediana', '5', '2', 'Contramuslo carne sin piel cruda sin hueso_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Muslo de pollo sin hueso y sin piel','F091','150','73','109,5','1 unidad mediana', '5', '2', 'Muslo de pollo sin hueso y sin piel_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Atún enlatado en aceite','E003','100','100','100','1/3 lata mediana', '5', '2', 'Atún enlatado en aceite_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Carne de cerdo','F011','150','100','150','1/8 de libra', '5', '2', 'Carne de cerdo_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Carne de res','F099','150','100','150','1/8 de libra', '5', '2', 'Carne de res_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Pechuga de pollo sin hueso sin piel','F085','150','93','139,5','1/4 de unidad mediana', '5', '2', 'Pechuga de pollo sin hueso sin piel_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Salmón rosado','E038','150','100','150','1 trozo pequeño', '5', '2', 'Salmón rosado_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Trucha arco iris','E047','150','52','78','1/2 unidad pequeña', '5', '2', 'Trucha arco iris_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Jamón','F052','210','100','210','4 tajadas', '5', '2', 'Jamón_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Contramuslo de pollo sin hueso y con piel','F073','165','91','150,15','1 unidad mediana', '5', '2', 'Contramuslo de pollo sin hueso y con piel_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Camarón, especies mezcladas','E017','155','87','134,85','37 unidades pequeñas', '5', '2', 'Camarón_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Alas de pollo','F069','140','71','99,4','1 unidad grande', '5', '2', 'Alas de pollo_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Hígado de pollo','F079','180','100','180','2 unidades medianas', '5', '2', 'Hígado de pollo_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Lengua de res','F013','207,5','100','207,5','1/6 de libra', '5', '2', 'engua de res_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Langostinos especies mezcladas','E024','187,5','47','88,125','3 unidades medianas', '5', '2', 'Langostinos especies mezcladas_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Callo o panza o mondongo','F097','250','100','250','1/5 de libra', '5', '2', 'Callo o panza o mondongo_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','7','Sardina enlatada en salsa de tomate','E040','200','100','200','1 trozo grande', '5', '2', 'Sardina enlatada en salsa de tomate_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','8','Huevo de gallina crudo','J004','125','90','112,5','1 unidad pequeña', '5', '2', 'Huevo de gallina crudo_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','9','Nuez del Brasil','C064','20','100','20','2 unidades medianas', '5', '2', 'Nuez del Brasil_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','9','Marañón tostado sin sal','C059','25','100','25','1 cucharada sopera colmada', '5', '2', 'Marañón tostado sin sal_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','9','Maní crudo con cáscara','T028','35','100','35','1 cucharada sopera colmada', '5', '2', 'Maní crudo con cáscara_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','9','Maní sin sal','T029','25','98','24,5','1 cucharada sopera colmada', '5', '2', 'Maní sin sal_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','9','Macadamia tostada sin sal','C046','15','100','15','3 unidades medianas', '5', '2', 'Macadamia tostada sin sal_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','9','Coco deshidratado','C020','22,5','100','22,5','1 cucharadas soperas colmadas', '5', '2', 'Coco deshidratado_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','9','Coco fresco rallado','C019','35','45','15,75','2 cucharadas sopera colmadas', '5', '2', 'Coco fresco rallado_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','10','Aceite de girasol','D004','7,5','100','7,5','1 cucharadita', '5', '2', 'Aceite de girasol_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','10','Aceite de maíz','D006','7,5','100','7,5','1 cucharadita', '5', '2', 'Aceite de maíz_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','10','Aceite de soya','D012','7,5','100','7,5','1 cucharadita', '5', '2', 'Aceite de soya_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','10','Aceite de ajonjolí','D001','7,5','100','7,5','1 cucharadita', '5', '2', 'Aceite de ajonjolí_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','10','Mayonesa comercial','D020','9','100','9','1 cucharadita dulcera rasa', '5', '2', 'Mayonesa comercial_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','10','Aceite de oliva','D008','7,5','100','7,5','1 cucharadita', '5', '2', 'Aceite de oliva_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','10','Aceite de canola','D003','7,5','100','7,5','1 cucharadita', '5', '2', 'Aceite de canola_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','10','Aguacate','C002','45','77','34,65','1/8 unidad', '5', '2', 'Aguacate_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','10','Margarinas suaves promedio','D019','7,5','100','7,5','1 cucharadita dulcera', '5', '2', 'Margarinas suaves promedio_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','10','Crema de leche líquida entera','G001','21','100','21','1 cucharada sopera alta', '5', '2', 'Crema de leche líquida entera_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','10','Tocineta','F022','10,5','100','10,5','1 tira', '5', '2', 'Tocineta_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','10','Queso crema','G014','19,5','100','19,5','1 cucharadita dulcera colmada', '5', '2', 'Queso crema_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','10','Mantequilla','D015','9','100','9','1 cucharadita dulcera rasa', '5', '2', 'Mantequilla_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','10','Aceite de palma','D009','7,5','100','7,5','1 cucharadita', '5', '2', 'Aceite de palma_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','10','Manteca de cerdo','D014','6','100','6','1 cucharadita dulcera', '5', '2', 'Manteca de cerdo_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','11','Azúcar granulada','K003','23','100','23','2 cucharadas soperas colmadas', '5', '2', 'Azúcar granulada_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','11','Miel de abejas','K031','21','100','21','1 cucharada sopera', '5', '2', 'Miel de abejas_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('2','11','Panela','K033','29','100','29','1 trozo pequeño', '5', '2', 'Panela_2_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','1','Pan blanco','A060','44','100','44','1 tajada delgada', '5', '2', 'Pan blanco_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','1','Harina de trigo refinada fortificada','A040','50','100','50','4 cucharadas soperas rasas', '5', '2', 'Harina de trigo refinada fortificada_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','1','Harina de maíz blanco trillado','A034','50','100','50','2 cucharadas soperas rasas', '5', '2', 'Harina de maíz blanco trillado_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','1','Arepa delgada de maíz blanco trillado','A006','112','100','112','1 unidad pequeña', '5', '2', 'Arepa delgada de maíz blanco trillado_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','1','Pasta larga, cocida','A073','128','100','128','2/3 de pocillo chocolatero', '5', '2', 'Pasta larga, cocida_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','1','Arroz blanco, cocido','A009','160','100','160','6 cucharadas soperas colmadas', '5', '2', 'Arroz blanco, cocido_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','1','Arroz integral, cocido','A011','162','100','162','8 cucharadas soperas colmadas o 2/3 de pocillo', '5', '2', 'Arroz integral, cocido_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','2','Arracacha sin cáscara cruda','B015','192','101','193,92','1 trozo pequeño', '5', '2', 'Arracacha sin cáscara cruda_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','2','Ñame sin cáscara cocido','P073','156','100','156','1 trozo pequeño', '5', '2', 'Ñame sin cáscara cocido_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','2','Yuca blanca cruda','B107','124','80','99,2','1 trozo mediano', '5', '2', 'Yuca blanca cruda_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','3','Papa común cocida','B073','166','100','166','1 unidad mediana', '5', '2', 'Papa común cocida_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','3','Batata cocida sin cáscara','B021','200','80','160','1 trozo pequeño', '5', '2', 'Batata cocida sin cáscara_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','3','Papa criolla cocida','B070','216','100','216','3 unidades medianas', '5', '2', 'Papa criolla cocida_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','4','Plátano verde sin cáscara','B091','156','100','156','1/2 unidad mediana', '5', '2', 'Plátano verde sin cáscara_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','4','Plátano colí o guineo crudo','B084','176','60','105,6','1 unidad mediana', '5', '2', 'Plátano colí o guineo crudo_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','4','Plátano hartón maduro sin cáscara cocido','B088','132','100','132','1/4 unidad mediana', '5', '2', 'Plátano hartón maduro sin cáscara cocido_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Bagre carne y piel','E008','140','92','128,8','1/3 de filete pequeño', '5', '2', 'Bagre carne y piel_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Carne de ternera','F131','120','100','120','1/8 de libra', '5', '2', 'Carne de ternera_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Contramuslo carne sin piel cruda sin hueso','F075','120','91','109,2','1 unidad mediana', '5', '2', 'Contramuslo carne sin piel cruda sin hueso_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Muslo de pollo sin hueso y sin piel','F091','120','73','87,6','1 unidad mediana', '5', '2', 'Muslo de pollo sin hueso y sin piel_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Atún enlatado en aceite','E003','80','100','80','1/3 lata mediana', '5', '2', 'Atún enlatado en aceite_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Carne de cerdo','F011','120','100','120','1/8 de libra', '5', '2', 'Carne de cerdo_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Carne de res','F099','120','100','120','1/8 de libra', '5', '2', 'Carne de res_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Pechuga de pollo sin hueso sin piel','F085','120','93','111,6','1/4 de unidad mediana', '5', '2', 'Pechuga de pollo sin hueso sin piel_3_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Salmón rosado','E038','120','100','120','1 trozo pequeño', '5', '2', 'Salmón rosado_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Trucha arco iris','E047','120','52','62,4','1/2 unidad pequeña', '5', '2', 'Trucha arco iris_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Jamón','F052','168','100','168','4 tajadas', '5', '2', 'Jamón_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Contramuslo de pollo sin hueso y con piel','F073','132','91','120,12','1 unidad mediana', '5', '2', 'Contramuslo de pollo sin hueso y con piel_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Camarón, especies mezcladas','E017','124','87','107,88','37 unidades pequeñas', '5', '2', 'Camarón, especies mezcladas_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Alas de pollo','F069','112','71','79,52','1 unidad grande', '5', '2', 'Alas de pollo_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Hígado de pollo','F079','144','100','144','2 unidades medianas', '5', '2', 'Hígado de pollo_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Lengua de res','F013','166','100','166','1/6 de libra', '5', '2', 'engua de res_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Langostinos especies mezcladas','E024','150','47','70,5','3 unidades medianas', '5', '2', 'Langostinos especies mezcladas_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Callo o panza o mondongo','F097','200','100','200','1/5 de libra', '5', '2', 'Callo o panza o mondongo_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','7','Sardina enlatada en salsa de tomate','E040','160','100','160','1 trozo grande', '5', '2', 'Sardina enlatada en salsa de tomate_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','8','Huevo de gallina crudo','J004','100','90','90','1 unidad pequeña', '5', '2', 'Huevo de gallina crudo_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','9','Nuez del Brasil','C064','16','100','16','2 unidades medianas', '5', '2', 'Nuez del Brasil_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','9','Marañón tostado sin sal','C059','20','100','20','1 cucharada sopera colmada', '5', '2', 'Marañón tostado sin sal_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','9','Maní crudo con cáscara','T028','28','100','28','1 cucharada sopera colmada', '5', '2', 'Maní crudo con cáscara_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','9','Maní sin sal','T029','20','98','19,6','1 cucharada sopera colmada', '5', '2', 'Maní sin sal_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','9','Macadamia tostada sin sal','C046','12','100','12','3 unidades medianas', '5', '2', 'Macadamia tostada sin sal_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','9','Coco deshidratado','C020','18','100','18','1 cucharadas soperas colmadas', '5', '2', 'Coco deshidratado_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','9','Coco fresco rallado','C019','28','45','12,6','2 cucharadas sopera colmadas', '5', '2', 'Coco fresco rallado_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','10','Aceite de girasol','D004','5','100','5','1 cucharadita', '5', '2', 'Aceite de girasol_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','10','Aceite de maíz','D006','5','100','5','1 cucharadita', '5', '2', 'Aceite de maíz_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','10','Aceite de soya','D012','5','100','5','1 cucharadita', '5', '2', 'Aceite de soya_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','10','Aceite de ajonjolí','D001','5','100','5','1 cucharadita', '5', '2', 'Aceite de ajonjolí_3_woman_3_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','10','Mayonesa comercial','D020','6','100','6','1 cucharadita dulcera rasa', '5', '2', 'Mayonesa comercial_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','10','Aceite de oliva','D008','5','100','5','1 cucharadita', '5', '2', 'Aceite de oliva_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','10','Aceite de canola','D003','5','100','5','1 cucharadita', '5', '2', 'Aceite de canola_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','10','Aguacate','C002','30','77','23,1','1/8 unidad', '5', '2', 'Aguacate_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','10','Margarinas suaves promedio','D019','5','100','5','1 cucharadita dulcera', '5', '2', 'Margarinas suaves promedio_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','10','Crema de leche líquida entera','G001','14','100','14','1 cucharada sopera alta', '5', '2', 'Crema de leche líquida entera_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','10','Tocineta','F022','7','100','7','1 tira', '5', '2', 'Tocineta_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','10','Queso crema','G014','13','100','13','1 cucharadita dulcera colmada', '5', '2', 'Tocineta_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','10','Mantequilla','D015','6','100','6','1 cucharadita dulcera rasa', '5', '2', 'Mantequilla_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','10','Aceite de palma','D009','5','100','5','1 cucharadita', '5', '2', 'Aceite de palma_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','10','Manteca de cerdo','D014','4','100','4','1 cucharadita dulcera', '5', '2', 'Manteca de cerdo_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','6','Leche de vaca en polvo entera','G008','27','100','27','6 cucharadas soperas rasas', '5', '2', 'Leche de vaca en polvo entera_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','6','Leche de vaca líquida entera pasterizada','G012','200','100','200','1 vaso mediano', '5', '2', 'Leche de vaca líquida entera pasterizada_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','6','Kumis, entero, con azúcar','G002','150','100','150','1 vaso pequeño', '5', '2', 'Kumis, entero, con azúcar_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','6','yogurt, bebible, entero, con azúcar','G028','150','100','150','1 vaso pequeño', '5', '2', 'yogurt, bebible, entero, con azúcar_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','6','Queso campesino','G017','20','100','20','1 tajada pequeña delgada', '5', '2', 'Queso campesino_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','6','Queso mozzarella de leche entera','G019','28','100','28','1 tajada semigruesa', '5', '2', 'Queso mozzarella de leche entera_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','6','Leche baja en grasa','G007','200','100','200','1 vaso mediano', '5', '2', 'Leche baja en grasa_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','6','Yogur dietético','N005','200','100','200','1 vaso mediano', '5', '2', 'Yogur dietético_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','13','Arveja verde','B019','42','40','16,8','3 cucharadas soperas', '5', '2', 'Arveja verde_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','13','Ahuyama o Zapallo','B006','68','85','57,8','1 trozo mediano', '5', '2', 'Ahuyama o Zapallo_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','13','Cebolla puerro','B030','50','95','47,5','1 tallo grueso', '5', '2', 'Cebolla puerro_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','13','Cebolla cabezona','B027','50','95','47,5','6 rodajas delgadas', '5', '2', 'Cebolla cabezona_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','13','Champiñones','B033','93','95','88,35','1/2 pocillo chocolatero', '5', '2', 'Champiñones_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','13','Coliflor','B039','86','80','68,8','3 gajos pequeños', '5', '2', 'Coliflor_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','13','Pimentón rojo','B080','88','85','74,8','1/2 unidad mediana', '5', '2', 'Pimentón rojo_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','13','Remolacha','B098','57','80','45,6','1/2 unidad pequeña', '5', '2', 'Remolacha_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','13','Repollo morado','B101','120','85','102','2 pocillos chocolateros', '5', '2', 'Repollo morado_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','13','Tomate rojo','B103','126','80','100,8','1 unidad grande', '5', '2', 'Tomate rojo_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','13','Zanahoria','B110','58','85','49,3','1/2 pocillo chocolatero', '5', '2', 'Zanahoria_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','13','Champiñones enlatados','B034','83','100','83','1/2 pocillo chocolatero', '5', '2', 'Champiñones enlatados_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','13','Espárragos enlatados','B041','105','100','105','19 tallos delgados', '5', '2', 'Espárragos enlatados_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','13','Habichuelas enlatadas','B051','100','100','100','3/4 pocillo (cuadros)', '5', '2', 'Habichuelas enlatadas_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','11','Azúcar granulada','K003','23','100','23','2 cucharadas soperas colmadas', '5', '2', 'Azúcar granulada_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','11','Miel de abejas','K031','21','100','21','1 cucharada sopera', '5', '2', 'Miel de abejas_3_woman_18-59' );
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id, skuu)  VALUES ('3','11','Panela','K033','29','100','29','1 trozo pequeño', '5', '2', 'Panela_3_woman_18-59' );





INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1', '1','Pan blanco','A060','44','100','44','1 tajada delgada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1', '1','Harina de trigo refinada fortificada','A040','50','100','50','4 cucharadas soperas rasas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1', '1','Harina de maíz blanco trillado','A034','50','100','50','2 cucharadas soperas rasas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1', '1','Arepa delgada de maíz blanco trillado','A006','112','100','112','1 unidad pequeña', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','1','Avena en hojuelas','A012','48','100','48','4 cucharadas soperas colmadas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','2','Arracacha sin cáscara cruda','B015','192','80','153,6','1 trozo pequeño', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1', '2', 'Ñame sin cáscara cocido','P073','156','100','156','1 trozo pequeño', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','2','Yuca blanca cruda','B107','124','80','99,2','1 trozo mediano', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','3','Papa común cocida','B073','166','100','166','1 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1', '3', 'Papa criolla cocida','B070','216','100','216','3 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','4','Plátano verde sin cáscara','B091','156','100','156','1/2 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','4','Plátano colí o guineo crudo','B084','176','60','105,6','1 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','4', 'Plátano hartón maduro sin cáscara cocido','B088','132','100','132','1/4 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Banano común','C010','65','70','45,5','1/2 unidad grande', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Fresas','C025','161','95','152,95','9 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Granadilla','C028','218','30','65,4','1 unidad grande', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Guanábana','C030','200','70','140','4 cucharadas soperas colmadas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Guayaba común','C031','200','75','150','1 unidad grande', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Kiwi','C042','164','91','149,24','1 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Mandarina','C050','210','70','147','1 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Mango','C051','224','50','112','1 unidad pequeña', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1', '5','Manzana','C054','224','85','190,4','1 unidad pequeña', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1', '5', 'Maracuyá','C056','194','32','62,08','2 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Melón','C060','252','50','126','1 tajada delgada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Moras de castilla','C061','432','90','388,8','38 unidades', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Naranja','C062','294','60','176,4','1 unidad pequeña', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Papaya','C065','256','70','179,2','1 trozo mediano', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Pera','C071','266','85','226,1','1/2 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1', '5','Piña','C072','230','55','126,5','1 tajada delgada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Tomate de árbol','C082','344','86','295,84','2 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Uchuvas','C084','138','94','129,72','13 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Leche de vaca en polvo entera','G008','54','100','54','6 cucharadas soperas rasas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Leche de vaca líquida entera pasterizada','G012','400','100','400','1 vaso mediano', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Kumis, entero, con azúcar','G002','300','100','300','1 vaso pequeño', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','yogurt, bebible, entero, con azúcar','G028','300','100','300','1 vaso pequeño', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Queso campesino','G017','40','100','40','1 tajada pequeña delgada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Queso mozzarella de leche entera','G019','56','100','56','1 tajada semigruesa', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Leche baja en grasa','G007','400','100','400','1 vaso mediano', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Yogur dietético','N005','400','100','400','1 vaso mediano', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','7','Atún enlatado en aceite','E003','100','100','100','1/3 lata mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','7','Carne de cerdo','F011','150','100','150','1/8 de libra', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','7','Carne de res','F099','150','100','150','1/8 de libra', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','8','Huevo de gallina crudo','J004','125','90','112,5','1 unidad pequeña', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Nuez del Brasil','C064','20','100','20','2 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Marañón tostado sin sal','C059','25','100','25','1 cucharada sopera colmada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Maní crudo con cáscara','T028','35','100','35','1 cucharada sopera colmada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9', 'Maní sin sal','T029','25','98','24,5','1 cucharada sopera colmada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Macadamia tostada sin sal','C046','15','100','15','3 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Coco deshidratado','C020','22,5','100','22,5','1 cucharadas soperas colmadas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9', 'Coco fresco rallado','C019','35','45','15,75','2 cucharadas sopera colmadas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de girasol','D004','10','100','10','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de maíz','D006','10','100','10','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de soya','D012','10','100','10','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de ajonjolí','D001','10','100','10','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Mayonesa comercial','D020','12','100','12','1 cucharadita dulcera rasa', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de oliva','D008','10','100','10','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de canola','D003','10','100','10','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aguacate','C002','60','77','46,2','1/8 unidad', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Margarinas suaves promedio','D019','10','100','10','1 cucharadita dulcera', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Crema de leche líquida entera','G001','28','100','28','1 cucharada sopera alta', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Tocineta','F022','14','100','14','1 tira', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Queso crema','G014','26','100','26','1 cucharadita dulcera colmada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Mantequilla','D015','12','100','12','1 cucharadita dulcera rasa', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de palma','D009','10','100','10','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Manteca de cerdo','D014','8','100','8','1 cucharadita dulcera', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','11','Azúcar granulada','K003','23','100','23','2 cucharadas soperas colmadas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','11','Miel de abejas','K031','21','100','21','1 cucharada sopera', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','11','Panela','K033','29','100','29','1 trozo pequeño', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Pan blanco','A060','88','100','88','1 tajada delgada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Harina de trigo refinada fortificada','A040','100','100','100','4 cucharadas soperas rasas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Harina de maíz blanco trillado','A034','100','100','100','2 cucharadas soperas rasas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Arepa delgada de maíz blanco trillado','A006','224','100','224','1 unidad pequeña', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Pasta larga, cocida','A073','256','100','256','2/3 de pocillo chocolatero', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Arroz blanco, cocido','A009','320','100','320','6 cucharadas soperas colmadas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Arroz integral, cocido','A011','324','100','324','8 cucharadas soperas colmadas o 2/3 de pocillo', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','2','Arracacha sin cáscara cruda','B015','384','80','307,2','1 trozo pequeño', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','2','Ñame sin cáscara cocido','P073','312','100','312','1 trozo pequeño', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','2','Yuca blanca cruda','B107','248','80','198,4','1 trozo mediano', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','3','Papa común cocida','B073','332','100','332','1 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','3','Batata cocida sin cáscara','B021','400','80','320','1 trozo pequeño', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','3','Papa criolla cocida','B070','432','100','432','3 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','4','Plátano verde sin cáscara','B091','312','100','312','1/2 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','4','Plátano colí o guineo crudo','B084','352','60','211,2','1 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','4','Plátano hartón maduro sin cáscara cocido','B088','264','100','264','1/4 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Arveja verde','B019','84','40','33,6','3 cucharadas soperas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Ahuyama o Zapallo','B006','136','85','115,6','1 trozo mediano', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Cebolla puerro','B030','100','95','95','1 tallo grueso', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Cebolla cabezona','B027','100','95','95','6 rodajas delgadas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Champiñones','B033','186','100','186','1/2 pocillo chocolatero', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Coliflor','B039','172','80','137,6','3 gajos pequeños', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Pimentón rojo','B080','176','85','149,6','1/2 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Remolacha','B098','114','80','91,2','1/2 unidad pequeña', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Repollo morado','B101','240','85','204','2 pocillos chocolateros', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Tomate rojo','B103','252','80','201,6','1 unidad grande', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Zanahoria','B110','116','85','98,6','1/2 pocillo chocolatero', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Champiñones enlatados','B034','166','100','166','1/2 pocillo chocolatero', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Espárragos enlatados','B041','210','100','210','19 tallos delgados', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Habichuelas enlatadas','B051','200','100','200','3/4 pocillo (cuadros)', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Banano común','C010','65','70','45,5','1/2 unidad grande', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Fresas','C025','161','95','152,95','9 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Granadilla','C028','218','30','65,4','1 unidad grande', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Guanábana','C030','200','70','140','4 cucharadas soperas colmadas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Guayaba común','C031','200','75','150','1 unidad grande', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Kiwi','C042','164','91','149,24','1 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Mandarina','C050','210','70','147','1 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Mango','C051','224','50','112','1 unidad pequeña', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Manzana','C054','224','85','190,4','1 unidad pequeña', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Maracuyá','C056','194','32','62,08','2 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Melón','C060','252','50','126','1 tajada delgada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Moras de castilla','C061','432','90','388,8','38 unidades', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Naranja','C062','294','60','176,4','1 unidad pequeña', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Papaya','C065','256','70','179,2','1 trozo mediano', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Pera','C071','266','85','226,1','1/2 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Piña','C072','230','55','126,5','1 tajada delgada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Tomate de árbol','C082','344','86','295,84','2 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Uchuvas','C084','138','94','129,72','13 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','6','Frijol cargamanto rosado con plátano verde*','T012','58,8','100','58,8','1/2 cucharón', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','6','Frijol bola roja con plátano verde*','T006','65','100','65','1/2 cucharón', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','6','Frijol nima con guiso**','T015','70','100','70','1/2 cucharón', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','6','Frijol caraota con guiso**','T009','70','100','70','1/2 cucharón', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','6','Frijol cabecita negra con guiso**','T007','70','100','70','1/2 cucharón', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','6','Garbanzo con guiso**','T019','49','100','49','1/2 cucharón', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','6','Soya con guiso**','T030','39','100','39','1/2 cucharón', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','6','Lenteja con guiso**','T026','54,6','100','54,6','1/2 cucharón', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Bagre carne y piel','E008','210','92','193,2','1/3 de filete pequeño', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Carne de ternera','F131','180','100','180','1/8 de libra', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Contramuslo carne sin piel cruda sin hueso','F075','180','91','163,8','1 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Muslo de pollo sin hueso y sin piel','F091','180','73','131,4','1 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Atún enlatado en aceite','E003','120','100','120','1/3 lata mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Carne de cerdo','F011','180','100','180','1/8 de libra', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Carne de res','F099','180','100','180','1/8 de libra', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Pechuga de pollo sin hueso sin piel','F085','180','93','167,4','1/4 de unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Salmón rosado','E038','180','100','180','1 trozo pequeño', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Trucha arco iris','E047','180','52','93,6','1/2 unidad pequeña', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Jamón','F052','252','100','252','4 tajadas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Contramuslo de pollo sin hueso y con piel','F073','198','91','180,18','1 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Camarón, especies mezcladas','E017','186','87','161,82','37 unidades pequeñas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Alas de pollo','F069','168','71','119,28','1 unidad grande', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Hígado de pollo','F079','216','100','216','2 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Lengua de res','F013','249','100','249','1/6 de libra', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Langostinos especies mezcladas','E024','225','47','105,75','3 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Callo o panza o mondongo','F097','300','100','300','1/5 de libra', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Sardina enlatada en salsa de tomate','E040','240','100','240','1 trozo grande', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','8','Huevo de gallina crudo','J004','150','90','135','1 unidad pequeña', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Nuez del Brasil','C064','24','100','24','2 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Marañón tostado sin sal','C059','30','100','30','1 cucharada sopera colmada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Maní crudo con cáscara','T028','42','100','42','1 cucharada sopera colmada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Maní sin sal','T029','30','98','29,4','1 cucharada sopera colmada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Macadamia tostada sin sal','C046','18','100','18','3 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Coco deshidratado','C020','27','100','27','1 cucharadas soperas colmadas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Coco fresco rallado','C019','42','45','18,9','2 cucharadas sopera colmadas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de girasol','D004','10','100','10','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de maíz','D006','10','100','10','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de soya','D012','10','100','10','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de ajonjolí','D001','10','100','10','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Mayonesa comercial','D020','12','100','12','1 cucharadita dulcera rasa', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de oliva','D008','10','100','10','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de canola','D003','10','100','10','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aguacate','C002','60','77','46,2','1/8 unidad', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Margarinas suaves promedio','D019','10','100','10','1 cucharadita dulcera', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Crema de leche líquida entera','G001','28','100','28','1 cucharada sopera alta', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Tocineta','F022','14','100','14','1 tira', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Queso crema','G014','26','100','26','1 cucharadita dulcera colmada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Mantequilla','D015','12','100','12','1 cucharadita dulcera rasa', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de palma','D009','10','100','10','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Manteca de cerdo','D014','8','100','8','1 cucharadita dulcera', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','11','Azúcar granulada','K003','23','100','23','2 cucharadas soperas colmadas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','11','Miel de abejas','K031','21','100','21','1 cucharada sopera', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','11','Panela','K033','29','100','29','1 trozo pequeño', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Pan blanco','A060','44','100','44','1 tajada delgada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Harina de trigo refinada fortificada','A040','50','100','50','4 cucharadas soperas rasas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Harina de maíz blanco trillado','A034','50','100','50','2 cucharadas soperas rasas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Arepa delgada de maíz blanco trillado','A006','112','100','112','1 unidad pequeña', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Pasta larga, cocida','A073','128','100','128','2/3 de pocillo chocolatero', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Arroz blanco, cocido','A009','160','100','160','6 cucharadas soperas colmadas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Arroz integral, cocido','A011','162','100','162','8 cucharadas soperas colmadas o 2/3 de pocillo', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','2','Arracacha sin cáscara cruda','B015','192','101','193,92','1 trozo pequeño', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','2','Ñame sin cáscara cocido','P073','156','100','156','1 trozo pequeño', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','2','Yuca blanca cruda','B107','124','80','99,2','1 trozo mediano', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','3','Papa común cocida','B073','166','100','166','1 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','3','Batata cocida sin cáscara','B021','200','80','160','1 trozo pequeño', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','3','Papa criolla cocida','B070','216','100','216','3 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','4','Plátano verde sin cáscara','B091','156','100','156','1/2 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','4','Plátano colí o guineo crudo','B084','176','60','105,6','1 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','4','Plátano hartón maduro sin cáscara cocido','B088','132','100','132','1/4 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Bagre carne y piel','E008','140','92','128,8','1/3 de filete pequeño', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Carne de ternera','F131','120','100','120','1/8 de libra', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Contramuslo carne sin piel cruda sin hueso','F075','120','91','109,2','1 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Muslo de pollo sin hueso y sin piel','F091','120','73','87,6','1 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Atún enlatado en aceite','E003','80','100','80','1/3 lata mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Carne de cerdo','F011','120','100','120','1/8 de libra', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Carne de res','F099','120','100','120','1/8 de libra', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Pechuga de pollo sin hueso sin piel','F085','120','93','111,6','1/4 de unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Salmón rosado','E038','120','100','120','1 trozo pequeño', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Trucha arco iris','E047','120','52','62,4','1/2 unidad pequeña', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Jamón','F052','168','100','168','4 tajadas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Contramuslo de pollo sin hueso y con piel','F073','132','91','120,12','1 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Camarón, especies mezcladas','E017','124','87','107,88','37 unidades pequeñas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Alas de pollo','F069','112','71','79,52','1 unidad grande', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Hígado de pollo','F079','144','100','144','2 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Lengua de res','F013','166','100','166','1/6 de libra', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Langostinos especies mezcladas','E024','150','47','70,5','3 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Callo o panza o mondongo','F097','200','100','200','1/5 de libra', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Sardina enlatada en salsa de tomate','E040','160','100','160','1 trozo grande', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','8','Huevo de gallina crudo','J004','100','90','90','1 unidad pequeña', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Nuez del Brasil','C064','16','100','16','2 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Marañón tostado sin sal','C059','20','100','20','1 cucharada sopera colmada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Maní crudo con cáscara','T028','28','100','28','1 cucharada sopera colmada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Maní sin sal','T029','20','98','19,6','1 cucharada sopera colmada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Macadamia tostada sin sal','C046','12','100','12','3 unidades medianas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Coco deshidratado','C020','18','100','18','1 cucharadas soperas colmadas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Coco fresco rallado','C019','28','45','12,6','2 cucharadas sopera colmadas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de girasol','D004','5','100','5','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de maíz','D006','5','100','5','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de soya','D012','5','100','5','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de ajonjolí','D001','5','100','5','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Mayonesa comercial','D020','6','100','6','1 cucharadita dulcera rasa', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de oliva','D008','5','100','5','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de canola','D003','5','100','5','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aguacate','C002','30','77','23,1','1/8 unidad', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Margarinas suaves promedio','D019','5','100','5','1 cucharadita dulcera', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Crema de leche líquida entera','G001','14','100','14','1 cucharada sopera alta', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Tocineta','F022','7','100','7','1 tira', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Queso crema','G014','13','100','13','1 cucharadita dulcera colmada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Mantequilla','D015','6','100','6','1 cucharadita dulcera rasa', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de palma','D009','5','100','5','1 cucharadita', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Manteca de cerdo','D014','4','100','4','1 cucharadita dulcera', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Leche de vaca en polvo entera','G008','54','100','54','6 cucharadas soperas rasas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Leche de vaca líquida entera pasterizada','G012','400','100','400','1 vaso mediano', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Kumis, entero, con azúcar','G002','300','100','300','1 vaso pequeño', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','yogurt, bebible, entero, con azúcar','G028','300','100','300','1 vaso pequeño', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Queso campesino','G017','40','100','40','1 tajada pequeña delgada', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Queso mozzarella de leche entera','G019','56','100','56','1 tajada semigruesa', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Leche baja en grasa','G007','400','100','400','1 vaso mediano', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Yogur dietético','N005','400','100','400','1 vaso mediano', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Arveja verde','B019','42','40','16,8','3 cucharadas soperas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Ahuyama o Zapallo','B006','68','85','57,8','1 trozo mediano', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Cebolla puerro','B030','50','95','47,5','1 tallo grueso', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Cebolla cabezona','B027','50','95','47,5','6 rodajas delgadas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Champiñones','B033','93','95','88,35','1/2 pocillo chocolatero', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Coliflor','B039','86','80','68,8','3 gajos pequeños', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Pimentón rojo','B080','88','85','74,8','1/2 unidad mediana', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Remolacha','B098','57','80','45,6','1/2 unidad pequeña', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Repollo morado','B101','120','85','102','2 pocillos chocolateros', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Tomate rojo','B103','126','80','100,8','1 unidad grande', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Zanahoria','B110','58','85','49,3','1/2 pocillo chocolatero', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Champiñones enlatados','B034','83','100','83','1/2 pocillo chocolatero', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Espárragos enlatados','B041','105','100','105','19 tallos delgados', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Habichuelas enlatadas','B051','100','100','100','3/4 pocillo (cuadros)', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','11','Azúcar granulada','K003','23','100','23','2 cucharadas soperas colmadas', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','11','Miel de abejas','K031','21','100','21','1 cucharada sopera', '5', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','11','Panela','K033','29','100','29','1 trozo pequeño', '5', '1');



INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','1','Pan blanco','A060','44','100','44','1 tajada delgada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','1','Harina de trigo refinada fortificada','A040','50','100','50','4 cucharadas soperas rasas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','1','Harina de maíz blanco trillado','A034','50','100','50','2 cucharadas soperas rasas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','1','Arepa delgada de maíz blanco trillado','A006','112','100','112','1 unidad pequeña', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','1','Avena en hojuelas','A012','48','100','48','4 cucharadas soperas colmadas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','2','Arracacha sin cáscara cruda','B015','192','80','153,6','1 trozo pequeño', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','2','Ñame sin cáscara cocido','P073','156','100','156','1 trozo pequeño', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','2','Yuca blanca cruda','B107','124','80','99,2','1 trozo mediano', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','3','Papa común cocida','B073','166','100','166','1 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','3','Papa criolla cocida','B070','216','100','216','3 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','4','Plátano verde sin cáscara','B091','156','100','156','1/2 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','4','Plátano colí o guineo crudo','B084','176','60','105,6','1 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','4','Plátano hartón maduro sin cáscara cocido','B088','132','100','132','1/4 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Banano común','C010','65','70','45,5','1/2 unidad grande', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Fresas','C025','161','95','152,95','9 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Granadilla','C028','218','30','65,4','1 unidad grande', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Guanábana','C030','200','70','140','4 cucharadas soperas colmadas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Guayaba común','C031','200','75','150','1 unidad grande', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Kiwi','C042','164','91','149,24','1 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Mandarina','C050','210','70','147','1 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Mango','C051','224','50','112','1 unidad pequeña', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Manzana','C054','224','85','190,4','1 unidad pequeña', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Maracuyá','C056','194','32','62,08','2 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Melón','C060','252','50','126','1 tajada delgada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Moras de castilla','C061','432','90','388,8','38 unidades', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Naranja','C062','294','60','176,4','1 unidad pequeña', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Papaya','C065','256','70','179,2','1 trozo mediano', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Pera','C071','266','85','226,1','1/2 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Piña','C072','230','55','126,5','1 tajada delgada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Tomate de árbol','C082','344','86','295,84','2 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Uchuvas','C084','138','94','129,72','13 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Leche de vaca en polvo entera','G008','54','100','54','6 cucharadas soperas rasas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Leche de vaca líquida entera pasterizada','G012','400','100','400','1 vaso mediano', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Kumis, entero, con azúcar','G002','300','100','300','1 vaso pequeño', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','yogurt, bebible, entero, con azúcar','G028','300','100','300','1 vaso pequeño', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Queso campesino','G017','40','100','40','1 tajada pequeña delgada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Queso mozzarella de leche entera','G019','56','100','56','1 tajada semigruesa', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Leche baja en grasa','G007','400','100','400','1 vaso mediano', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Yogur dietético','N005','400','100','400','1 vaso mediano', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','7','Atún enlatado en aceite','E003','80','100','80','1/3 lata mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','7','Carne de cerdo','F011','120','100','120','1/8 de libra', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','7','Carne de res','F099','120','100','120','1/8 de libra', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','8','Huevo de gallina crudo','J004','100','90','90','1 unidad pequeña', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Nuez del Brasil','C064','16','100','16','2 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Marañón tostado sin sal','C059','20','100','20','1 cucharada sopera colmada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Maní crudo con cáscara','T028','28','100','28','1 cucharada sopera colmada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Maní sin sal','T029','20','98','19,6','1 cucharada sopera colmada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Macadamia tostada sin sal','C046','12','100','12','3 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Coco deshidratado','C020','18','100','18','1 cucharadas soperas colmadas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Coco fresco rallado','C019','28','45','12,6','2 cucharadas sopera colmadas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de girasol','D004','7,5','100','7,5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de maíz','D006','7,5','100','7,5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de soya','D012','7,5','100','7,5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de ajonjolí','D001','7,5','100','7,5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Mayonesa comercial','D020','9','100','9','1 cucharadita dulcera rasa', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de oliva','D008','7,5','100','7,5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de canola','D003','7,5','100','7,5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aguacate','C002','45','77','34,65','1/8 unidad', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Margarinas suaves promedio','D019','7,5','100','7,5','1 cucharadita dulcera', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Crema de leche líquida entera','G001','21','100','21','1 cucharada sopera alta', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Tocineta','F022','10,5','100','10,5','1 tira', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Queso crema','G014','19,5','100','19,5','1 cucharadita dulcera colmada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Mantequilla','D015','9','100','9','1 cucharadita dulcera rasa', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de palma','D009','7,5','100','7,5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Manteca de cerdo','D014','6','100','6','1 cucharadita dulcera', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','11','Azúcar granulada','K003','23','100','23','2 cucharadas soperas colmadas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','11','Miel de abejas','K031','21','100','21','1 cucharada sopera', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','11','Panela','K033','29','100','29','1 trozo pequeño', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Pan blanco','A060','44','100','44','1 tajada delgada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Harina de trigo refinada fortificada','A040','50','100','50','4 cucharadas soperas rasas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Harina de maíz blanco trillado','A034','50','100','50','2 cucharadas soperas rasas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Arepa delgada de maíz blanco trillado','A006','112','100','112','1 unidad pequeña', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Pasta larga, cocida','A073','128','100','128','2/3 de pocillo chocolatero', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Arroz blanco, cocido','A009','160','100','160','6 cucharadas soperas colmadas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Arroz integral, cocido','A011','162','100','162','8 cucharadas soperas colmadas o 2/3 de pocillo', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','2','Arracacha sin cáscara cruda','B015','192','80','153,6','1 trozo pequeño', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','2','Ñame sin cáscara cocido','P073','156','100','156','1 trozo pequeño', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','2','Yuca blanca cruda','B107','124','80','99,2','1 trozo mediano', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','3','Papa común cocida','B073','166','100','166','1 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','3','Batata cocida sin cáscara','B021','200','80','160','1 trozo pequeño', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','3','Papa criolla cocida','B070','216','100','216','3 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','4','Plátano verde sin cáscara','B091','156','100','156','1/2 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','4','Plátano colí o guineo crudo','B084','176','60','105,6','1 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','4','Plátano hartón maduro sin cáscara cocido','B088','132','100','132','1/4 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Arveja verde','B019','42','40','16,8','3 cucharadas soperas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Ahuyama o Zapallo','B006','68','85','57,8','1 trozo mediano', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Cebolla puerro','B030','50','95','47,5','1 tallo grueso', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Cebolla cabezona','B027','50','95','47,5','6 rodajas delgadas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Champiñones','B033','93','100','93','1/2 pocillo chocolatero', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Coliflor','B039','86','80','68,8','3 gajos pequeños', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Pimentón rojo','B080','88','85','74,8','1/2 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Remolacha','B098','57','80','45,6','1/2 unidad pequeña', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Repollo morado','B101','120','85','102','2 pocillos chocolateros', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Tomate rojo','B103','126','80','100,8','1 unidad grande', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Zanahoria','B110','58','85','49,3','1/2 pocillo chocolatero', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Champiñones enlatados','B034','83','100','83','1/2 pocillo chocolatero', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Espárragos enlatados','B041','105','100','105','19 tallos delgados', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Habichuelas enlatadas','B051','100','100','100','3/4 pocillo (cuadros)', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Banano común','C010','65','70','45,5','1/2 unidad grande', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Fresas','C025','161','95','152,95','9 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Granadilla','C028','54,5','30','16,35','1 unidad grande', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Guanábana','C030','50','70','35','4 cucharadas soperas colmadas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Guayaba común','C031','50','75','37,5','1 unidad grande', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Kiwi','C042','41','91','37,31','1 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Mandarina','C050','52,5','70','36,75','1 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Mango','C051','56','50','28','1 unidad pequeña', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Manzana','C054','56','85','47,6','1 unidad pequeña', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Maracuyá','C056','48,5','32','15,52','2 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Melón','C060','63','50','31,5','1 tajada delgada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Moras de castilla','C061','108','90','97,2','38 unidades', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Naranja','C062','73,5','60','44,1','1 unidad pequeña', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Papaya','C065','64','70','44,8','1 trozo mediano', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Pera','C071','66,5','85','56,525','1/2 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Piña','C072','57,5','55','31,625','1 tajada delgada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Tomate de árbol','C082','86','86','73,96','2 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Uchuvas','C084','34,5','94','32,43','13 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','12','Frijol cargamanto rosado con plátano verde*','T012','58,8','100','58,8','1/2 cucharón', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','12','Frijol bola roja con plátano verde*','T006','65','100','65','1/2 cucharón', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','12','Frijol nima con guiso**','T015','70','100','70','1/2 cucharón', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','12','Frijol caraota con guiso**','T009','70','100','70','1/2 cucharón', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','12','Frijol cabecita negra con guiso**','T007','70','100','70','1/2 cucharón', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','12','Garbanzo con guiso**','T019','49','100','49','1/2 cucharón', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','12','Soya con guiso**','T030','39','100','39','1/2 cucharón', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','12','Lenteja con guiso**','T026','54,6','100','54,6','1/2 cucharón', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Bagre carne y piel','E008','175','92','161','1/3 de filete pequeño', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Carne de ternera','F131','150','100','150','1/8 de libra', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Contramuslo carne sin piel cruda sin hueso','F075','150','91','136,5','1 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Muslo de pollo sin hueso y sin piel','F091','150','73','109,5','1 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Atún enlatado en aceite','E003','100','100','100','1/3 lata mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Carne de cerdo','F011','150','100','150','1/8 de libra', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Carne de res','F099','150','100','150','1/8 de libra', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Pechuga de pollo sin hueso sin piel','F085','150','93','139,5','1/4 de unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Salmón rosado','E038','150','100','150','1 trozo pequeño', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Trucha arco iris','E047','150','52','78','1/2 unidad pequeña', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Jamón','F052','210','100','210','4 tajadas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Contramuslo de pollo sin hueso y con piel','F073','165','91','150,15','1 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Camarón, especies mezcladas','E017','155','87','134,85','37 unidades pequeñas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Alas de pollo','F069','140','71','99,4','1 unidad grande', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Hígado de pollo','F079','180','100','180','2 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Lengua de res','F013','207,5','100','207,5','1/6 de libra', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Langostinos especies mezcladas','E024','187,5','47','88,125','3 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Callo o panza o mondongo','F097','250','100','250','1/5 de libra', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Sardina enlatada en salsa de tomate','E040','200','100','200','1 trozo grande', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','8','Huevo de gallina crudo','J004','125','90','112,5','1 unidad pequeña', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Nuez del Brasil','C064','20','100','20','2 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Marañón tostado sin sal','C059','25','100','25','1 cucharada sopera colmada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Maní crudo con cáscara','T028','35','100','35','1 cucharada sopera colmada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Maní sin sal','T029','25','98','24,5','1 cucharada sopera colmada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Macadamia tostada sin sal','C046','15','100','15','3 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Coco deshidratado','C020','22,5','100','22,5','1 cucharadas soperas colmadas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Coco fresco rallado','C019','35','45','15,75','2 cucharadas sopera colmadas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de girasol','D004','7,5','100','7,5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de maíz','D006','7,5','100','7,5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de soya','D012','7,5','100','7,5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de ajonjolí','D001','7,5','100','7,5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Mayonesa comercial','D020','9','100','9','1 cucharadita dulcera rasa', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de oliva','D008','7,5','100','7,5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de canola','D003','7,5','100','7,5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aguacate','C002','45','77','34,65','1/8 unidad', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Margarinas suaves promedio','D019','7,5','100','7,5','1 cucharadita dulcera', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Crema de leche líquida entera','G001','21','100','21','1 cucharada sopera alta', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Tocineta','F022','10,5','100','10,5','1 tira', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Queso crema','G014','19,5','100','19,5','1 cucharadita dulcera colmada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Mantequilla','D015','9','100','9','1 cucharadita dulcera rasa', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de palma','D009','7,5','100','7,5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Manteca de cerdo','D014','6','100','6','1 cucharadita dulcera', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','11','Azúcar granulada','K003','23','100','23','2 cucharadas soperas colmadas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','11','Miel de abejas','K031','21','100','21','1 cucharada sopera', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','11','Panela','K033','29','100','29','1 trozo pequeño', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Pan blanco','A060','44','100','44','1 tajada delgada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Harina de trigo refinada fortificada','A040','50','100','50','4 cucharadas soperas rasas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Harina de maíz blanco trillado','A034','50','100','50','2 cucharadas soperas rasas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Arepa delgada de maíz blanco trillado','A006','112','100','112','1 unidad pequeña', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Pasta larga, cocida','A073','128','100','128','2/3 de pocillo chocolatero', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Arroz blanco, cocido','A009','160','100','160','6 cucharadas soperas colmadas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Arroz integral, cocido','A011','162','100','162','8 cucharadas soperas colmadas o 2/3 de pocillo', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','2','Arracacha sin cáscara cruda','B015','192','101','193,92','1 trozo pequeño', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','2','Ñame sin cáscara cocido','P073','156','100','156','1 trozo pequeño', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','2','Yuca blanca cruda','B107','124','80','99,2','1 trozo mediano', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','3','Papa común cocida','B073','166','100','166','1 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','3','Batata cocida sin cáscara','B021','200','80','160','1 trozo pequeño', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','3','Papa criolla cocida','B070','216','100','216','3 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','4','Plátano verde sin cáscara','B091','156','100','156','1/2 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','4','Plátano colí o guineo crudo','B084','176','60','105,6','1 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','4','Plátano hartón maduro sin cáscara cocido','B088','132','100','132','1/4 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Bagre carne y piel','E008','140','92','128,8','1/3 de filete pequeño', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Carne de ternera','F131','120','100','120','1/8 de libra', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Contramuslo carne sin piel cruda sin hueso','F075','120','91','109,2','1 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Muslo de pollo sin hueso y sin piel','F091','120','73','87,6','1 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Atún enlatado en aceite','E003','80','100','80','1/3 lata mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Carne de cerdo','F011','120','100','120','1/8 de libra', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Carne de res','F099','120','100','120','1/8 de libra', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Pechuga de pollo sin hueso sin piel','F085','120','93','111,6','1/4 de unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Salmón rosado','E038','120','100','120','1 trozo pequeño', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Trucha arco iris','E047','120','52','62,4','1/2 unidad pequeña', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Jamón','F052','168','100','168','4 tajadas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Contramuslo de pollo sin hueso y con piel','F073','132','91','120,12','1 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Camarón, especies mezcladas','E017','124','87','107,88','37 unidades pequeñas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Alas de pollo','F069','112','71','79,52','1 unidad grande', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Hígado de pollo','F079','144','100','144','2 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Lengua de res','F013','166','100','166','1/6 de libra', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Langostinos especies mezcladas','E024','150','47','70,5','3 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Callo o panza o mondongo','F097','200','100','200','1/5 de libra', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Sardina enlatada en salsa de tomate','E040','160','100','160','1 trozo grande', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','8','Huevo de gallina crudo','J004','100','90','90','1 unidad pequeña', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Nuez del Brasil','C064','16','100','16','2 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Marañón tostado sin sal','C059','20','100','20','1 cucharada sopera colmada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Maní crudo con cáscara','T028','28','100','28','1 cucharada sopera colmada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Maní sin sal','T029','20','98','19,6','1 cucharada sopera colmada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Macadamia tostada sin sal','C046','12','100','12','3 unidades medianas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Coco deshidratado','C020','18','100','18','1 cucharadas soperas colmadas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Coco fresco rallado','C019','28','45','12,6','2 cucharadas sopera colmadas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de girasol','D004','5','100','5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de maíz','D006','5','100','5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de soya','D012','5','100','5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de ajonjolí','D001','5','100','5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Mayonesa comercial','D020','6','100','6','1 cucharadita dulcera rasa', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de oliva','D008','5','100','5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de canola','D003','5','100','5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aguacate','C002','30','77','23,1','1/8 unidad', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Margarinas suaves promedio','D019','5','100','5','1 cucharadita dulcera', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Crema de leche líquida entera','G001','14','100','14','1 cucharada sopera alta', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Tocineta','F022','7','100','7','1 tira', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Queso crema','G014','13','100','13','1 cucharadita dulcera colmada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Mantequilla','D015','6','100','6','1 cucharadita dulcera rasa', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de palma','D009','5','100','5','1 cucharadita', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Manteca de cerdo','D014','4','100','4','1 cucharadita dulcera', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Leche de vaca en polvo entera','G008','27','100','27','6 cucharadas soperas rasas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Leche de vaca líquida entera pasterizada','G012','200','100','200','1 vaso mediano', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Kumis, entero, con azúcar','G002','150','100','150','1 vaso pequeño', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','yogurt, bebible, entero, con azúcar','G028','150','100','150','1 vaso pequeño', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Queso campesino','G017','20','100','20','1 tajada pequeña delgada', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Queso mozzarella de leche entera','G019','28','100','28','1 tajada semigruesa', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Leche baja en grasa','G007','200','100','200','1 vaso mediano', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Yogur dietético','N005','200','100','200','1 vaso mediano', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Arveja verde','B019','42','40','16,8','3 cucharadas soperas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Ahuyama o Zapallo','B006','68','85','57,8','1 trozo mediano', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Cebolla puerro','B030','50','95','47,5','1 tallo grueso', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Cebolla cabezona','B027','50','95','47,5','6 rodajas delgadas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Champiñones','B033','93','95','88,35','1/2 pocillo chocolatero', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Coliflor','B039','86','80','68,8','3 gajos pequeños', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Pimentón rojo','B080','88','85','74,8','1/2 unidad mediana', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Remolacha','B098','57','80','45,6','1/2 unidad pequeña', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Repollo morado','B101','120','85','102','2 pocillos chocolateros', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Tomate rojo','B103','126','80','100,8','1 unidad grande', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Zanahoria','B110','58','85','49,3','1/2 pocillo chocolatero', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Champiñones enlatados','B034','83','100','83','1/2 pocillo chocolatero', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Espárragos enlatados','B041','105','100','105','19 tallos delgados', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Habichuelas enlatadas','B051','100','100','100','3/4 pocillo (cuadros)', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','11','Azúcar granulada','K003','23','100','23','2 cucharadas soperas colmadas', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','11','Miel de abejas','K031','21','100','21','1 cucharada sopera', '4', '2');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','11','Panela','K033','29','100','29','1 trozo pequeño', '4', '2');



INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1',' 1','Pan blanco','A060','44','100','44','1 tajada delgada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','1','Harina de trigo refinada fortificada','A040','50','100','50','4 cucharadas soperas rasas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','1','Harina de maíz blanco trillado','A034','50','100','50','2 cucharadas soperas rasas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','1','Arepa delgada de maíz blanco trillado','A006','112','100','112','1 unidad pequeña', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','1','Avena en hojuelas','A012','48','100','48','4 cucharadas soperas colmadas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','2','Arracacha sin cáscara cruda','B015','192','80','153,6','1 trozo pequeño', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','2','Ñame sin cáscara cocido','P073','156','100','156','1 trozo pequeño', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','2','Yuca blanca cruda','B107','124','80','99,2','1 trozo mediano', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','3','Papa común cocida','B073','166','100','166','1 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','3','Papa criolla cocida','B070','216','100','216','3 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','4','Plátano verde sin cáscara','B091','156','100','156','1/2 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','4','Plátano colí o guineo crudo','B084','176','60','105,6','1 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','4','Plátano hartón maduro sin cáscara cocido','B088','132','100','132','1/4 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Banano común','C010','65','70','45,5','1/2 unidad grande', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Fresas','C025','161','95','152,95','9 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Granadilla','C028','218','30','65,4','1 unidad grande', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Guanábana','C030','200','70','140','4 cucharadas soperas colmadas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Guayaba común','C031','200','75','150','1 unidad grande', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Kiwi','C042','164','91','149,24','1 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Mandarina','C050','210','70','147','1 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Mango','C051','224','50','112','1 unidad pequeña', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Manzana','C054','224','85','190,4','1 unidad pequeña', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Maracuyá','C056','194','32','62,08','2 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Melón','C060','252','50','126','1 tajada delgada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Moras de castilla','C061','432','90','388,8','38 unidades', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Naranja','C062','294','60','176,4','1 unidad pequeña', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Papaya','C065','256','70','179,2','1 trozo mediano', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Pera','C071','266','85','226,1','1/2 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Piña','C072','230','55','126,5','1 tajada delgada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Tomate de árbol','C082','344','86','295,84','2 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','5','Uchuvas','C084','138','94','129,72','13 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Leche de vaca en polvo entera','G008','54','100','54','6 cucharadas soperas rasas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Leche de vaca líquida entera pasterizada','G012','400','100','400','1 vaso mediano', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Kumis, entero, con azúcar','G002','300','100','300','1 vaso pequeño', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','yogurt, bebible, entero, con azúcar','G028','300','100','300','1 vaso pequeño', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Queso campesino','G017','40','100','40','1 tajada pequeña delgada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Queso mozzarella de leche entera','G019','56','100','56','1 tajada semigruesa', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Leche baja en grasa','G007','400','100','400','1 vaso mediano', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','6','Yogur dietético','N005','400','100','400','1 vaso mediano', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','7','CARNE','Atún enlatado en aceite','E003','120','100','120','1/3 lata mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','7','Carne de cerdo','F011','180','100','180','1/8 de libra', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','7','Carne de res','F099','180','100','180','1/8 de libra', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','8','Huevo de gallina crudo','J004','150','90','135','1 unidad pequeña', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Nuez del Brasil','C064','24','100','24','2 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Marañón tostado sin sal','C059','30','100','30','1 cucharada sopera colmada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Maní crudo con cáscara','T028','42','100','42','1 cucharada sopera colmada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Maní sin sal','T029','30','98','29,4','1 cucharada sopera colmada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Macadamia tostada sin sal','C046','18','100','18','3 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Coco deshidratado','C020','27','100','27','1 cucharadas soperas colmadas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','9','Coco fresco rallado','C019','42','45','18,9','2 cucharadas sopera colmadas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de girasol','D004','10','100','10','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de maíz','D006','10','100','10','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de soya','D012','10','100','10','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de ajonjolí','D001','10','100','10','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Mayonesa comercial','D020','12','100','12','1 cucharadita dulcera rasa', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de oliva','D008','10','100','10','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de canola','D003','10','100','10','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aguacate','C002','60','77','46,2','1/8 unidad', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Margarinas suaves promedio','D019','10','100','10','1 cucharadita dulcera', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Crema de leche líquida entera','G001','28','100','28','1 cucharada sopera alta', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Tocineta','F022','14','100','14','1 tira', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Queso crema','G014','26','100','26','1 cucharadita dulcera colmada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Mantequilla','D015','12','100','12','1 cucharadita dulcera rasa', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Aceite de palma','D009','10','100','10','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','10','Manteca de cerdo','D014','8','100','8','1 cucharadita dulcera', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','11','Azúcar granulada','K003','34,5','100','34,5','2 cucharadas soperas colmadas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','11','Miel de abejas','K031','31,5','100','31,5','1 cucharada sopera', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('1','11','Panela','K033','43,5','100','43,5','1 trozo pequeño', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Pan blanco','A060','88','100','88','1 tajada delgada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Harina de trigo refinada fortificada','A040','100','100','100','4 cucharadas soperas rasas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Harina de maíz blanco trillado','A034','100','100','100','2 cucharadas soperas rasas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Arepa delgada de maíz blanco trillado','A006','224','100','224','1 unidad pequeña', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Pasta larga, cocida','A073','256','100','256','2/3 de pocillo chocolatero', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Arroz blanco, cocido','A009','320','100','320','6 cucharadas soperas colmadas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','1','Arroz integral, cocido','A011','324','100','324','8 cucharadas soperas colmadas o 2/3 de pocillo', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','2','Arracacha sin cáscara cruda','B015','384','80','307,2','1 trozo pequeño', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','2','Ñame sin cáscara cocido','P073','312','100','312','1 trozo pequeño', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','2','Yuca blanca cruda','B107','248','80','198,4','1 trozo mediano', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','3','Papa común cocida','B073','332','100','332','1 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','3','Batata cocida sin cáscara','B021','400','80','320','1 trozo pequeño', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','3','Papa criolla cocida','B070','432','100','432','3 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','4','Plátano verde sin cáscara','B091','312','100','312','1/2 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','4','Plátano colí o guineo crudo','B084','352','60','211,2','1 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','4','Plátano hartón maduro sin cáscara cocido','B088','264','100','264','1/4 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Arveja verde','B019','84','40','33,6','3 cucharadas soperas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Ahuyama o Zapallo','B006','136','85','115,6','1 trozo mediano', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Cebolla puerro','B030','100','95','95','1 tallo grueso', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Cebolla cabezona','B027','100','95','95','6 rodajas delgadas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Champiñones','B033','186','100','186','1/2 pocillo chocolatero', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Coliflor','B039','172','80','137,6','3 gajos pequeños', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Pimentón rojo','B080','176','85','149,6','1/2 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Remolacha','B098','114','80','91,2','1/2 unidad pequeña', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Repollo morado','B101','240','85','204','2 pocillos chocolateros', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Tomate rojo','B103','252','80','201,6','1 unidad grande', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Zanahoria','B110','116','85','98,6','1/2 pocillo chocolatero', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Champiñones enlatados','B034','166','100','166','1/2 pocillo chocolatero', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Espárragos enlatados','B041','210','100','210','19 tallos delgados', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','13','Habichuelas enlatadas','B051','200','100','200','3/4 pocillo (cuadros)', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Banano común','C010','65','70','45,5','1/2 unidad grande', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Fresas','C025','161','95','152,95','9 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Granadilla','C028','218','30','65,4','1 unidad grande', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Guanábana','C030','200','70','140','4 cucharadas soperas colmadas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Guayaba común','C031','200','75','150','1 unidad grande', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Kiwi','C042','164','91','149,24','1 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Mandarina','C050','210','70','147','1 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Mango','C051','224','50','112','1 unidad pequeña', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Manzana','C054','224','85','190,4','1 unidad pequeña', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Maracuyá','C056','194','32','62,08','2 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Melón','C060','252','50','126','1 tajada delgada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Moras de castilla','C061','432','90','388,8','38 unidades', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Naranja','C062','294','60','176,4','1 unidad pequeña', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Papaya','C065','256','70','179,2','1 trozo mediano', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Pera','C071','266','85','226,1','1/2 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Piña','C072','230','55','126,5','1 tajada delgada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Tomate de árbol','C082','344','86','295,84','2 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','5','Uchuvas','C084','138','94','129,72','13 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','12','Frijol cargamanto rosado con plátano verde*','T012','58,8','100','58,8','1/2 cucharón', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','12','Frijol bola roja con plátano verde*','T006','65','100','65','1/2 cucharón', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','12','Frijol nima con guiso**','T015','70','100','70','1/2 cucharón', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','12','Frijol caraota con guiso**','T009','70','100','70','1/2 cucharón', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','12','Frijol cabecita negra con guiso**','T007','70','100','70','1/2 cucharón', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','12','Garbanzo con guiso**','T019','49','100','49','1/2 cucharón', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','12','Soya con guiso**','T030','39','100','39','1/2 cucharón', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','12','Lenteja con guiso**','T026','54,6','100','54,6','1/2 cucharón', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Bagre carne y piel','E008','210','92','193,2','1/3 de filete pequeño', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Carne de ternera','F131','180','100','180','1/8 de libra', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Contramuslo carne sin piel cruda sin hueso','F075','180','91','163,8','1 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Muslo de pollo sin hueso y sin piel','F091','180','73','131,4','1 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Atún enlatado en aceite','E003','120','100','120','1/3 lata mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Carne de cerdo','F011','180','100','180','1/8 de libra', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Carne de res','F099','180','100','180','1/8 de libra', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Pechuga de pollo sin hueso sin piel','F085','180','93','167,4','1/4 de unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Salmón rosado','E038','180','100','180','1 trozo pequeño', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Trucha arco iris','E047','180','52','93,6','1/2 unidad pequeña', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Jamón','F052','252','100','252','4 tajadas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Contramuslo de pollo sin hueso y con piel','F073','198','91','180,18','1 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Camarón, especies mezcladas','E017','186','87','161,82','37 unidades pequeñas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Alas de pollo','F069','168','71','119,28','1 unidad grande', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Hígado de pollo','F079','216','100','216','2 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Lengua de res','F013','249','100','249','1/6 de libra', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Langostinos especies mezcladas','E024','225','47','105,75','3 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Callo o panza o mondongo','F097','300','100','300','1/5 de libra', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','7','Sardina enlatada en salsa de tomate','E040','240','100','240','1 trozo grande', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','8','Huevo de gallina crudo','J004','150','90','135','1 unidad pequeña', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Nuez del Brasil','C064','24','100','24','2 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Marañón tostado sin sal','C059','30','100','30','1 cucharada sopera colmada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Maní crudo con cáscara','T028','42','100','42','1 cucharada sopera colmada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Maní sin sal','T029','30','98','29,4','1 cucharada sopera colmada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Macadamia tostada sin sal','C046','18','100','18','3 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Coco deshidratado','C020','27','100','27','1 cucharadas soperas colmadas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','9','Coco fresco rallado','C019','42','45','18,9','2 cucharadas sopera colmadas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de girasol','D004','10','100','10','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de maíz','D006','10','100','10','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de soya','D012','10','100','10','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de ajonjolí','D001','10','100','10','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Mayonesa comercial','D020','12','100','12','1 cucharadita dulcera rasa', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de oliva','D008','10','100','10','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de canola','D003','10','100','10','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aguacate','C002','60','77','46,2','1/8 unidad', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Margarinas suaves promedio','D019','10','100','10','1 cucharadita dulcera', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Crema de leche líquida entera','G001','28','100','28','1 cucharada sopera alta', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Tocineta','F022','14','100','14','1 tira', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Queso crema','G014','26','100','26','1 cucharadita dulcera colmada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Mantequilla','D015','12','100','12','1 cucharadita dulcera rasa', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Aceite de palma','D009','10','100','10','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','10','Manteca de cerdo','D014','8','100','8','1 cucharadita dulcera', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','11','Azúcar granulada','K003','23','100','23','2 cucharadas soperas colmadas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','11','Miel de abejas','K031','21','100','21','1 cucharada sopera', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('2','11','Panela','K033','29','100','29','1 trozo pequeño', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Pan blanco','A060','2,5','55','100','55','1 tajada delgada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Harina de trigo refinada fortificada','A040','62,5','100','62,5','4 cucharadas soperas rasas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Harina de maíz blanco trillado','A034','62,5','100','62,5','2 cucharadas soperas rasas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Arepa delgada de maíz blanco trillado','A006','140','100','140','1 unidad pequeña', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Pasta larga, cocida','A073','160','100','160','2/3 de pocillo chocolatero', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Arroz blanco, cocido','A009','200','100','200','6 cucharadas soperas colmadas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','1','Arroz integral, cocido','A011','202,5','100','202,5','8 cucharadas soperas colmadas o 2/3 de pocillo', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','2','Arracacha sin cáscara cruda','B015','240','101','242,4','1 trozo pequeño', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','2','Ñame sin cáscara cocido','P073','195','100','195','1 trozo pequeño', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','2','Yuca blanca cruda','B107','155','80','124','1 trozo mediano', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','3','Papa común cocida','B073','207,5','100','207,5','1 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','3','Batata cocida sin cáscara','B021','250','80','200','1 trozo pequeño', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','3','Papa criolla cocida','B070','270','100','270','3 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','4','Plátano verde sin cáscara','B091','195','100','195','1/2 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','4','Plátano colí o guineo crudo','B084','220','60','132','1 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','4','Plátano hartón maduro sin cáscara cocido','B088','165','100','165','1/4 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Bagre carne y piel','E008','140','92','128,8','1/3 de filete pequeño', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Carne de ternera','F131','120','100','120','1/8 de libra', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Contramuslo carne sin piel cruda sin hueso','F075','120','91','109,2','1 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Muslo de pollo sin hueso y sin piel','F091','120','73','87,6','1 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Atún enlatado en aceite','E003','80','100','80','1/3 lata mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Carne de cerdo','F011','120','100','120','1/8 de libra', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Carne de res','F099','120','100','120','1/8 de libra', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Pechuga de pollo sin hueso sin piel','F085','120','93','111,6','1/4 de unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Salmón rosado','E038','120','100','120','1 trozo pequeño', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Trucha arco iris','E047','120','52','62,4','1/2 unidad pequeña', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Jamón','F052','168','100','168','4 tajadas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Contramuslo de pollo sin hueso y con piel','F073','132','91','120,12','1 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Camarón, especies mezcladas','E017','124','87','107,88','37 unidades pequeñas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Alas de pollo','F069','112','71','79,52','1 unidad grande', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Hígado de pollo','F079','144','100','144','2 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Lengua de res','F013','166','100','166','1/6 de libra', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Langostinos especies mezcladas','E024','150','47','70,5','3 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Callo o panza o mondongo','F097','200','100','200','1/5 de libra', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','7','Sardina enlatada en salsa de tomate','E040','160','100','160','1 trozo grande', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','8','Huevo de gallina crudo','J004','100','90','90','1 unidad pequeña', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Nuez del Brasil','C064','16','100','16','2 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Marañón tostado sin sal','C059','20','100','20','1 cucharada sopera colmada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Maní crudo con cáscara','T028','28','100','28','1 cucharada sopera colmada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Maní sin sal','T029','20','98','19,6','1 cucharada sopera colmada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Macadamia tostada sin sal','C046','12','100','12','3 unidades medianas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Coco deshidratado','C020','18','100','18','1 cucharadas soperas colmadas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','9','Coco fresco rallado','C019','28','45','12,6','2 cucharadas sopera colmadas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de girasol','D004','5','100','5','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de maíz','D006','5','100','5','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de soya','D012','5','100','5','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de ajonjolí','D001','5','100','5','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Mayonesa comercial','D020','6','100','6','1 cucharadita dulcera rasa', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de oliva','D008','5','100','5','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de canola','D003','5','100','5','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aguacate','C002','30','77','23,1','1/8 unidad', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Margarinas suaves promedio','D019','5','100','5','1 cucharadita dulcera', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Crema de leche líquida entera','G001','14','100','14','1 cucharada sopera alta', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Tocineta','F022','7','100','7','1 tira', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Queso crema','G014','13','100','13','1 cucharadita dulcera colmada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Mantequilla','D015','6','100','6','1 cucharadita dulcera rasa', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Aceite de palma','D009','5','100','5','1 cucharadita', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','10','Manteca de cerdo','D014','4','100','4','1 cucharadita dulcera', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Leche de vaca en polvo entera','G008','54','100','54','6 cucharadas soperas rasas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Leche de vaca líquida entera pasterizada','G012','400','100','400','1 vaso mediano', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Kumis, entero, con azúcar','G002','300','100','300','1 vaso pequeño', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','yogurt, bebible, entero, con azúcar','G028','300','100','300','1 vaso pequeño', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Queso campesino','G017','40','100','40','1 tajada pequeña delgada', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Queso mozzarella de leche entera','G019','56','100','56','1 tajada semigruesa', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Leche baja en grasa','G007','400','100','400','1 vaso mediano', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','6','Yogur dietético','N005','400','100','400','1 vaso mediano', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Arveja verde','B019','63','40','25,2','3 cucharadas soperas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Ahuyama o Zapallo','B006','102','85','86,7','1 trozo mediano', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Cebolla puerro','B030','75','95','71,25','1 tallo grueso', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Cebolla cabezona','B027','75','95','71,25','6 rodajas delgadas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Champiñones','B033','139,5','95','132,525','1/2 pocillo chocolatero', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Coliflor','B039','129','80','103,2','3 gajos pequeños', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Pimentón rojo','B080','132','85','112,2','1/2 unidad mediana', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Remolacha','B098','85,5','80','68,4','1/2 unidad pequeña', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Repollo morado','B101','180','85','153','2 pocillos chocolateros', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Tomate rojo','B103','189','80','151,2','1 unidad grande', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Zanahoria','B110','87','85','73,95','1/2 pocillo chocolatero', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Champiñones enlatados','B034','124,5','100','124,5','1/2 pocillo chocolatero', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Espárragos enlatados','B041','157,5','100','157,5','19 tallos delgados', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','13','Habichuelas enlatadas','B051','150','100','150','3/4 pocillo (cuadros)', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','11','Azúcar granulada','K003','23','100','23','2 cucharadas soperas colmadas', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','11','Miel de abejas','K031','21','100','21','1 cucharada sopera', '4', '1');
INSERT INTO food_component(category_id, category_food_component_id, name,code, gross_weight, useful_weight, net_weight, unit_measure_home, age_ranges_id, gender_id) VALUES ('3','11','Panela','K033','29','100','29','1 trozo pequeño', '4', '1');


INSERT INTO foods(id, name, category_id) values('1','Tortilla de huevo con puré', '1');
INSERT INTO foods(id, name, category_id) values('2','Huevos revueltos con platano madura', '1');
INSERT INTO foods(id, name, category_id) values('3','Huevos pochados con queso', '1');
INSERT INTO foods(id, name, category_id) values('4','Omele de huevos con galletas', '1');
INSERT INTO foods(id, name, category_id) values('5','Tortilla de huevo con espinaca', '1');
INSERT INTO foods(id, name, category_id) values('6','Huevos con zanahoria rallada', '1');
INSERT INTO foods(id, name, category_id) values('7','Huevos revueltos con queso derretido', '1');

INSERT INTO foods(id, name, category_id) values ('8', 'Tilapia con arroz de verduras', '2');
INSERT INTO foods(id, name, category_id) values ('9', 'Crema de ahuyama, carne y ensalada', '2');
INSERT INTO foods(id, name, category_id) values ('10', 'Pechuga asada, arroz y ensalada', '2');
INSERT INTO foods(id, name, category_id) values ('11', 'Pollodo horneado y papa cocida', '2');
INSERT INTO foods(id, name, category_id) values ('12', 'Carne de res asada con yuca', '2');
INSERT INTO foods(id, name, category_id) values ('13', 'Filete de tilapia con ensalada', '2');
INSERT INTO foods(id, name, category_id) values ('14', 'Pollo salteado al wok y papa cocida', '2');

INSERT INTO foods(id, name, category_id) values ('15', 'Croqueta de espinaca', '4');
INSERT INTO foods(id, name, category_id) values ('16', 'Sandwich de berenjena', '4');
INSERT INTO foods(id, name, category_id) values ('17', 'Sandwich de atún', '4');
INSERT INTO foods(id, name, category_id) values ('18', 'Ensalada cesar', '4');
INSERT INTO foods(id, name, category_id) values ('19', 'Tortilla con queso, maiz y verdura', '4');
INSERT INTO foods(id, name, category_id) values ('20', 'Quesadilla con queso crema y pico gallo', '4');
INSERT INTO foods(id, name, category_id) values ('21', 'Sandwich cubano', '4');