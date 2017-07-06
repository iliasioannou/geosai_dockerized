CREATE TABLE IF NOT EXISTS privileges (
    `idPrivilege` serial PRIMARY KEY,
    code character varying NOT NULL,
    name character varying(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS roles (
    `idRole` serial PRIMARY KEY,
    name character varying(20) NOT NULL,
    code character varying NOT NULL
);

CREATE TABLE IF NOT EXISTS `rolesPrivileges` (
    `idRolePrivilege` serial PRIMARY KEY,
    `idPrivilege` integer NOT NULL,
    `idRole` integer NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
    `idUser` serial PRIMARY KEY,
    email character varying(320) NOT NULL,
    name character varying(50) NOT NULL,
    surname character varying(50) NOT NULL,
    username character varying(20) NOT NULL,
    password character varying(20) NOT NULL,
    `idRole` integer NOT NULL,
    active integer NOT NULL,
    note character varying(256)
);

ALTER TABLE ONLY `rolesPrivileges`
    ADD CONSTRAINT idprivilege_idrole UNIQUE (`idPrivilege`, `idRole`);

ALTER TABLE ONLY `rolesPrivileges`
    ADD CONSTRAINT privileges_rolesprivilages_fk FOREIGN KEY (`idPrivilege`) REFERENCES privileges(idPrivilege);

ALTER TABLE ONLY `rolesPrivileges`
    ADD CONSTRAINT roles_rolesprivileges_fk FOREIGN KEY (`idRole`) REFERENCES roles(idRole);

ALTER TABLE ONLY users
    ADD CONSTRAINT roles_users_fk FOREIGN KEY (`idRole`) REFERENCES roles(idRole);

INSERT INTO privileges VALUES (4, 'mng-user', 'manage users1');
INSERT INTO privileges VALUES (6, 'ondemand', 'on demand processings');

INSERT INTO roles VALUES (2, 'User', 'user');
INSERT INTO roles VALUES (7, 'Simple user', 'su');
INSERT INTO roles VALUES (1, 'Administrator', 'admin');

INSERT INTO `rolesPrivileges` VALUES (8, 4, 1);
INSERT INTO `rolesPrivileges` VALUES (11, 6, 2);

INSERT INTO users VALUES (34, 'testadmin@test.it', 'testadmin', 'testadmin', 'testadmin', 'testadmin', 1, 1, 'admin');
INSERT INTO users VALUES (37, 'user@user.it', 'user', 'user', 'user', 'user', 2, 1, 'user');
INSERT INTO users VALUES (42, 'anonymus@anonymous.com', 'anonymous', 'anonymous', 'anonymous', 'anonymous', 7, 1, 'utente');

