CREATE TABLE IF NOT EXISTS  RM_ENVIRONMENT(
  ID SERIAL NOT NULL,
  NAME VARCHAR(128) NOT NULL,
  CONSTRAINT PK_RM_ENVIRONMENT_01 PRIMARY KEY (ID),
  CONSTRAINT UNQ_RM_ENVIRONMENT_01 UNIQUE (NAME)
);

CREATE TABLE IF NOT EXISTS  RM_SERVER_INSTANCE (
  ID SERIAL NOT NULL,
  ENVIRONMENT_ID INTEGER NOT NULL,
  NAME VARCHAR(128) NOT NULL,
  SERVER_URL VARCHAR(1024) NOT NULL,
  DBMS_TYPE VARCHAR(128) NOT NULL,
  INSTANCE_TYPE VARCHAR(128) NOT NULL,
  SERVER_CATEGORY VARCHAR(128) NOT NULL,
  ADMIN_USERNAME VARCHAR(128),
  ADMIN_PASSWORD VARCHAR(128),
  DRIVER_CLASS VARCHAR(128) NOT NULL ,
  TENANT_ID INTEGER NOT NULL,
  SSH_HOST VARCHAR(128),
  SSH_PORT INTEGER,
  SSH_USERNAME VARCHAR(128),
  SNAPSHOT_TARGET_DIRECTORY VARCHAR(1024),
  CONSTRAINT UNQ_RM_SERVER_INSTANCE_01 UNIQUE  (NAME, ENVIRONMENT_ID, TENANT_ID),
  CONSTRAINT PK_RM_SERVER_INSTANCE_01 PRIMARY KEY (ID),
  CONSTRAINT FK_RM_SERVER_INSTANCE_01 FOREIGN KEY (ENVIRONMENT_ID) REFERENCES RM_ENVIRONMENT (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS  RM_DATABASE (
  ID SERIAL NOT NULL,
  NAME VARCHAR(128) NOT NULL,
  RSS_INSTANCE_ID INTEGER NOT NULL,
  TYPE VARCHAR(15) NOT NULL,
  TENANT_ID INTEGER NOT NULL,
  CONSTRAINT UNQ_RM_DATABASE_01 UNIQUE (NAME, RSS_INSTANCE_ID, TENANT_ID),
  CONSTRAINT PK_RM_DATABASE_01 PRIMARY KEY (ID),
  CONSTRAINT FK_RM_DATABASE_01 FOREIGN KEY (RSS_INSTANCE_ID) REFERENCES RM_SERVER_INSTANCE (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS  RM_DATABASE_USER (
  ID SERIAL NOT NULL,
  USERNAME VARCHAR(16) NOT NULL,
  ENVIRONMENT_ID INTEGER NOT NULL,
  RSS_INSTANCE_ID INTEGER NOT NULL DEFAULT -1,
  TYPE VARCHAR(15) NOT NULL,
  TENANT_ID INTEGER NOT NULL,
  CONSTRAINT UNQ_RM_DATABASE_USER_01 UNIQUE (USERNAME, TENANT_ID, ENVIRONMENT_ID, RSS_INSTANCE_ID),
  CONSTRAINT PK_RM_DATABASE_USER_01 PRIMARY KEY (ID)
);

CREATE TABLE IF NOT EXISTS  RM_USER_DATABASE_ENTRY (
  ID SERIAL NOT NULL,
  DATABASE_USER_ID INTEGER NOT NULL,
  DATABASE_ID INTEGER NOT NULL,
  CONSTRAINT PK_RM_USER_DATABASE_ENTRY_01 PRIMARY KEY (ID),
  CONSTRAINT UNQ_RM_USER_DATABASE_ENTRY_01 UNIQUE (DATABASE_USER_ID, DATABASE_ID),
  CONSTRAINT FK_RM_USER_DATABASE_ENTRY_01 FOREIGN KEY (DATABASE_USER_ID) REFERENCES RM_DATABASE_USER (ID) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT FK_RM_USER_DATABASE_ENTRY_02 FOREIGN KEY (DATABASE_ID) REFERENCES RM_DATABASE (ID) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS  RM_USER_DATABASE_PRIVILEGE (
  ID SERIAL NOT NULL,
  USER_DATABASE_ENTRY_ID INTEGER NOT NULL,
  SELECT_PRIV VARCHAR(15) NOT NULL,
  INSERT_PRIV VARCHAR(15) NOT NULL,
  UPDATE_PRIV VARCHAR(15) NOT NULL,
  DELETE_PRIV VARCHAR(15) NOT NULL,
  CREATE_PRIV VARCHAR(15) NOT NULL,
  DROP_PRIV VARCHAR(15) NOT NULL,
  GRANT_PRIV VARCHAR(15) NOT NULL,
  REFERENCES_PRIV VARCHAR(15) NOT NULL,
  INDEX_PRIV VARCHAR(15) NOT NULL,
  ALTER_PRIV VARCHAR(15) NOT NULL,
  CREATE_TMP_TABLE_PRIV VARCHAR(15) NOT NULL,
  LOCK_TABLES_PRIV VARCHAR(15) NOT NULL,
  CREATE_VIEW_PRIV VARCHAR(15) NOT NULL,
  SHOW_VIEW_PRIV VARCHAR(15) NOT NULL,
  CREATE_ROUTINE_PRIV VARCHAR(15) NOT NULL,
  ALTER_ROUTINE_PRIV VARCHAR(15) NOT NULL,
  EXECUTE_PRIV VARCHAR(15) NOT NULL,
  EVENT_PRIV VARCHAR(15) NOT NULL,
  TRIGGER_PRIV VARCHAR(15) NOT NULL,
  CONSTRAINT PK_RM_USER_DATABASE_PRIVILEGE_01 PRIMARY KEY (ID),
  CONSTRAINT UNQ_RM_USER_DATABASE_PRIVILEGE_01 UNIQUE (USER_DATABASE_ENTRY_ID),
  CONSTRAINT FK_RM_USER_DATABASE_PRIVILEGE_01 FOREIGN KEY (USER_DATABASE_ENTRY_ID) REFERENCES RM_USER_DATABASE_ENTRY (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS  RM_SYSTEM_DATABASE_COUNT (
  ID SERIAL NOT NULL,
  COUNT INTEGER NOT NULL DEFAULT 0,
  ENVIRONMENT_ID INTEGER NOT NULL,	
  CONSTRAINT PK_RM_SYSTEM_DATABASE_COUNT_01 PRIMARY KEY (ID),
  CONSTRAINT FK_RM_SYSTEM_DATABASE_COUNT_01 FOREIGN KEY (ENVIRONMENT_ID) REFERENCES RM_ENVIRONMENT (ID)
);

CREATE TABLE IF NOT EXISTS  RM_DB_PRIVILEGE_TEMPLATE (
  ID SERIAL NOT NULL,
  ENVIRONMENT_ID INTEGER NOT NULL,
  NAME VARCHAR(128) NOT NULL,
  TENANT_ID INTEGER NOT NULL,
  CONSTRAINT PK_RM_DB_PRIVILEGE_TEMPLATE_01 PRIMARY KEY (ID),
  CONSTRAINT UNQ_RM_DB_PRIVILEGE_TEMPLATE_01 UNIQUE (ENVIRONMENT_ID, NAME, TENANT_ID),
  CONSTRAINT FK_RM_DB_PRIVILEGE_TEMPLATE_01 FOREIGN KEY (ENVIRONMENT_ID) REFERENCES RM_ENVIRONMENT (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS  RM_DB_PRIVILEGE_TEMPLATE_ENTRY (
  ID SERIAL NOT NULL,
  TEMPLATE_ID INTEGER NOT NULL,
  SELECT_PRIV VARCHAR(15) NOT NULL,
  INSERT_PRIV VARCHAR(15) NOT NULL,
  UPDATE_PRIV VARCHAR(15) NOT NULL,
  DELETE_PRIV VARCHAR(15) NOT NULL,
  CREATE_PRIV VARCHAR(15) NOT NULL,
  DROP_PRIV VARCHAR(15) NOT NULL,
  GRANT_PRIV VARCHAR(15) NOT NULL,
  REFERENCES_PRIV VARCHAR(15) NOT NULL,
  INDEX_PRIV VARCHAR(15) NOT NULL,
  ALTER_PRIV VARCHAR(15) NOT NULL,
  CREATE_TMP_TABLE_PRIV VARCHAR(15) NOT NULL,
  LOCK_TABLES_PRIV VARCHAR(15) NOT NULL,
  CREATE_VIEW_PRIV VARCHAR(15) NOT NULL,
  SHOW_VIEW_PRIV VARCHAR(15) NOT NULL,
  CREATE_ROUTINE_PRIV VARCHAR(15) NOT NULL,
  ALTER_ROUTINE_PRIV VARCHAR(15) NOT NULL,
  EXECUTE_PRIV VARCHAR(15) NOT NULL,
  EVENT_PRIV VARCHAR(15) NOT NULL,
  TRIGGER_PRIV VARCHAR(15) NOT NULL,
  CONSTRAINT PK_RM_DB_PRIVILEGE_TEMPLATE_ENTRY_01 PRIMARY KEY (ID),
  CONSTRAINT FK_RM_DB_PRIVILEGE_TEMPLATE_ENTRY_01 FOREIGN KEY (TEMPLATE_ID) REFERENCES RM_DB_PRIVILEGE_TEMPLATE (ID) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS  RM_USER_INSTANCE_ENTRY (
 RSS_INSTANCE_ID INTEGER NOT NULL ,
 DATABASE_USER_ID INTEGER NOT NULL ,
 CONSTRAINT PK_RM_USER_INSTANCE_ENTRY_01 PRIMARY KEY (RSS_INSTANCE_ID,DATABASE_USER_ID) ,
 CONSTRAINT FK_RM_USER_INSTANCE_ENTRY_01 FOREIGN KEY (DATABASE_USER_ID) REFERENCES RM_DATABASE_USER (ID ) ON DELETE CASCADE ON UPDATE CASCADE,
 CONSTRAINT FK_RM_USER_INSTANCE_ENTRY_02 FOREIGN KEY (RSS_INSTANCE_ID ) REFERENCES RM_SERVER_INSTANCE (ID ) ON DELETE CASCADE ON UPDATE CASCADE 
);

