INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_vigne', 'Vigneron', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_vigne', 'Vigneron', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_vigne', 'Vigneron', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('vigne', 'Vigneron')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('vigne',0,'recruit','Recrue',0,'{}','{}'),
	('vigne',1,'novice','Novice',0,'{}','{}'),
	('vigne',2,'experimente','Experimenté',0,'{}','{}'),
	('vigne',3,'viceboss','Co Patron',0,'{}','{}'),
	('vigne',4,'boss','Patron',0,'{}','{}')
;

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
	('raisinr', 'Raisin Rouge', 1),
	('raisinb', 'Raisin Blanc', 1),
	('jus_raisin_rouge', 'Jus de raisin Rouge', 1),
	('jus_raisin_blanc', 'Jus de raisin Blanc', 1),
	('vin_rouge', 'Vin Rouge', 1),
	('vin_blanc', 'Vin Blanc', 1),
	('grand_cru', 'Grand cru', 1),
	('champagne', 'Champagne', 1),
	('golem', 'Golem', 1)
;