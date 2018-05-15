/* Create The Database */

DROP DATABASE automated_warehouse_management;

CREATE DATABASE IF NOT EXISTS automated_warehouse_management;

/* Change To automated_warehouse_management Database */

use automated_warehouse_management;

/* Create Tables */

DROP TABLE storage_unit;

CREATE TABLE storage_unit (
		id INT NOT NULL AUTO_INCREMENT,
		storage_unit_name CHAR(15) NOT NULL,
		no_of_items INT NOT NULL,
		max_capacity INT NOT NULL,
		PRIMARY KEY(id)
);

DROP TABLE sensor_data;

CREATE TABLE sensor_data (
	id INT NOT NULL AUTO_INCREMENT,
	time_stamp TIMESTAMP NOT NULL,
	humidity float,
	temperature float,
	luminance float,
	PRIMARY KEY(id)
);

DROP TABLE ev3_robot;

CREATE TABLE ev3_robot (
	id INT NOT NULL AUTO_INCREMENT,
	time_stamp TIMESTAMP NOT NULL,
	job_id INT NOT NULL,
	status CHAR(15) NOT NULL,
	ev3_position CHAR(15),
	PRIMARY KEY(id)
);

/* Create a Trigger To Auto Increment The JOB_ID After The Previous Job's Status Changes To Done */

DELIMITER $$
CREATE TRIGGER `job_id_trigger` BEFORE INSERT ON `ev3_robot` FOR EACH ROW
BEGIN
	DECLARE prev_job_id INT;

	SELECT job_id
	INTO prev_job_id
	FROM ev3_robot
	WHERE status = 'Done'
	ORDER BY time_stamp DESC
	LIMIT 1;

	set NEW.job_id=(prev_job_id) + 1;
END $$

DELIMITER ;