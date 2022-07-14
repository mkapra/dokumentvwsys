CREATE TABLE users (
  id serial NOT NULL,

  username character varying(255) NOT NULL,
  first_name character varying(255) NOT NULL,
  last_name character varying(255) NOT NULL,
  birthdate date NOT NULL,
  password character varying(255) NOT NULL,
  role integer NOT NULL,

  CONSTRAINT users_pkey PRIMARY KEY (id)
);