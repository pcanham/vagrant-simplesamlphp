CREATE TABLE users (
  uid VARCHAR(30) NOT NULL PRIMARY KEY,
  password TEXT NOT NULL,
  salt TEXT NOT NULL,
  givenName TEXT NOT NULL,
  email TEXT NOT NULL,
  eduPersonPrincipalName TEXT NOT NULL
);
CREATE TABLE usergroups (
  uid TEXT REFERENCES users (uid) ON DELETE CASCADE ON UPDATE CASCADE,
  groupname TEXT,
  UNIQUE(uid, groupname)
);
