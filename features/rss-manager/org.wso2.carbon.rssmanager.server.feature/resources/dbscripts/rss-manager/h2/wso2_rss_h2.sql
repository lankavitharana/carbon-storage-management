CREATE TABLE RM_ENVIRONMENT(
  ID INTEGER NOT NULL AUTO_INCREMENT,
  NAME VARCHAR(128) NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE (NAME)
);

CREATE TABLE RM_SERVER_INSTANCE (
  ID INTEGER NOT NULL AUTO_INCREMENT,
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
  UNIQUE (NAME, ENVIRONMENT_ID, TENANT_ID),
  PRIMARY KEY (ID),
  FOREIGN KEY (ENVIRONMENT_ID) REFERENCES RM_ENVIRONMENT (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE RM_DATABASE (
  ID INTEGER NOT NULL AUTO_INCREMENT,
  NAME VARCHAR(128) NOT NULL,
  RSS_INSTANCE_ID VARCHAR(128) NOT NULL,
  TENANT_ID INTEGER NOT NULL,
  TYPE VARCHAR(15) NOT NULL,
  UNIQUE (NAME, RSS_INSTANCE_ID, TENANT_ID),
  PRIMARY KEY (ID),
  FOREIGN KEY (RSS_INSTANCE_ID) REFERENCES RM_SERVER_INSTANCE (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE RM_DATABASE_USER (
  ID INTEGER NOT NULL AUTO_INCREMENT,
  USERNAME VARCHAR(16) NOT NULL,
  ENVIRONMENT_ID INTEGER NOT NULL,
  TYPE VARCHAR(15) NOT NULL,
  TENANT_ID INTEGER NOT NULL,
  UNIQUE (USERNAME, ENVIRONMENT_ID, TENANT_ID),
  PRIMARY KEY (ID),
);

CREATE TABLE RM_USER_DATABASE_ENTRY (
  ID INTEGER NOT NULL AUTO_INCREMENT,
  DATABASE_USER_ID INTEGER NOT NULL,
  DATABASE_ID INTEGER NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE (DATABASE_USER_ID, DATABASE_ID),
  FOREIGN KEY (DATABASE_USER_ID) REFERENCES RM_DATABASE_USER (ID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (DATABASE_ID) REFERENCES RM_DATABASE (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE RM_USER_DATABASE_PRIVILEGE (
  ID INTEGER NOT NULL AUTO_INCREMENT,
  USER_DATABASE_ENTRY_ID INTEGER NOT NULL,
  SELECT_PRIV CHAR(1) NOT NULL,
  INSERT_PRIV CHAR(1) NOT NULL,
  UPDATE_PRIV CHAR(1) NOT NULL,
  DELETE_PRIV CHAR(1) NOT NULL,
  CREATE_PRIV CHAR(1) NOT NULL,
  DROP_PRIV CHAR(1) NOT NULL,
  GRANT_PRIV CHAR(1) NOT NULL,
  REFERENCES_PRIV CHAR(1) NOT NULL,
  INDEX_PRIV CHAR(1) NOT NULL,
  ALTER_PRIV CHAR(1) NOT NULL,
  CREATE_TMP_TABLE_PRIV CHAR(1) NOT NULL,
  LOCK_TABLES_PRIV CHAR(1) NOT NULL,
  CREATE_VIEW_PRIV CHAR(1) NOT NULL,
  SHOW_VIEW_PRIV CHAR(1) NOT NULL,
  CREATE_ROUTINE_PRIV CHAR(1) NOT NULL,
  ALTER_ROUTINE_PRIV CHAR(1) NOT NULL,
  EXECUTE_PRIV CHAR(1) NOT NULL,
  EVENT_PRIV CHAR(1) NOT NULL,
  TRIGGER_PRIV CHAR(1) NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE (USER_DATABASE_ENTRY_ID),
  FOREIGN KEY (USER_DATABASE_ENTRY_ID) REFERENCES RM_USER_DATABASE_ENTRY (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE RM_DB_PRIVILEGE_TEMPLATE (
  ID INTEGER NOT NULL AUTO_INCREMENT,
  ENVIRONMENT_ID INTEGER NOT NULL,
  NAME VARCHAR(128) NOT NULL,
  TENANT_ID INTEGER NOT NULL,
  PRIMARY KEY (ID),
  UNIQUE (ENVIRONMENT_ID, NAME, TENANT_ID),
  FOREIGN KEY (ENVIRONMENT_ID) REFERENCES RM_ENVIRONMENT (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE RM_DB_PRIVILEGE_TEMPLATE_ENTRY (
  ID INTEGER NOT NULL AUTO_INCREMENT,
  TEMPLATE_ID INTEGER NOT NULL,
  SELECT_PRIV CHAR(1) NOT NULL,
  INSERT_PRIV CHAR(1) NOT NULL,
  UPDATE_PRIV CHAR(1) NOT NULL,
  DELETE_PRIV CHAR(1) NOT NULL,
  CREATE_PRIV CHAR(1) NOT NULL,
  DROP_PRIV CHAR(1) NOT NULL,
  GRANT_PRIV CHAR(1) NOT NULL,
  REFERENCES_PRIV CHAR(1) NOT NULL,
  INDEX_PRIV CHAR(1) NOT NULL,
  ALTER_PRIV CHAR(1) NOT NULL,
  CREATE_TMP_TABLE_PRIV CHAR(1) NOT NULL,
  LOCK_TABLES_PRIV CHAR(1) NOT NULL,
  CREATE_VIEW_PRIV CHAR(1) NOT NULL,
  SHOW_VIEW_PRIV CHAR(1) NOT NULL,
  CREATE_ROUTINE_PRIV CHAR(1) NOT NULL,
  ALTER_ROUTINE_PRIV CHAR(1) NOT NULL,
  EXECUTE_PRIV CHAR(1) NOT NULL,
  EVENT_PRIV CHAR(1) NOT NULL,
  TRIGGER_PRIV CHAR(1) NOT NULL,
  PRIMARY KEY (ID),
  FOREIGN KEY (TEMPLATE_ID) REFERENCES RM_DB_PRIVILEGE_TEMPLATE (ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE RM_USER_INSTANCE_ENTRY (
  RSS_INSTANCE_ID INTEGER NOT NULL,
  DATABASE_USER_ID INTEGER NOT NULL,
  PRIMARY KEY (RSS_INSTANCE_ID,DATABASE_USER_ID),
  FOREIGN KEY (DATABASE_USER_ID) REFERENCES RM_DATABASE_USER (ID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (RSS_INSTANCE_ID ) REFERENCES RM_SERVER_INSTANCE (ID) ON DELETE CASCADE ON UPDATE CASCADE
)