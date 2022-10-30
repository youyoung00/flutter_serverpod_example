--
-- Class ImageData as table image_data
--

CREATE TABLE image_data (
  "id" serial,
  "pixels" bytea NOT NULL,
  "width" integer NOT NULL,
  "height" integer NOT NULL
);

ALTER TABLE ONLY image_data
  ADD CONSTRAINT image_data_pkey PRIMARY KEY (id);


--
-- Class User as table users
--

CREATE TABLE users (
  "id" serial,
  "name" text NOT NULL,
  "image" text NOT NULL
);

ALTER TABLE ONLY users
  ADD CONSTRAINT users_pkey PRIMARY KEY (id);


