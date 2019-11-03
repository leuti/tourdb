-- =====================
-- == Check migration ==
-- =====================


-- ---------------------------------
-- Migrate data for table kmlstyles'
-- ---------------------------------

-- ----------------------------
-- Migrate data for table users
-- ----------------------------

-- -------------------------------------
-- tourdb_new.areas (load regions first)
-- -------------------------------------

-- ----------------
-- tourdb_new.types
-- ----------------
-- types (old)
SELECT 
	"old" AS source,
	tourdb2_prod.tbl_types.typCode AS `type`,
	tourdb2_prod.tbl_types.typName AS `name`,
	ptype.typCode AS `parent`,
	tourdb2_prod.tbl_types.typPurpose AS `purpose`
FROM tourdb2_prod.tbl_types
left OUTER JOIN tourdb2_prod.tbl_types ptype ON tourdb2_prod.tbl_types.typParentId = ptype.typId

-- types (new)
UNION ALL SELECT 
	"new" AS source,
	tourdb_new.types.code AS `type`,
	tourdb_new.types.name AS `name`,
	ptype.code AS `parent`,
--	SELECT CONVERT("W3Schools.com" USING latin1);
	CONVERT(types.usage USING UTF8) AS `purpose`
FROM tourdb_new.types
left outer JOIN tourdb_new.types ptype ON tourdb_new.types.fk_parentId = ptype.typeId
ORDER BY `parent`, `type`, `source`


-- -----------------
-- tourdb_new.grades
-- -----------------

-- --------------------
-- tourdb_new.waypoints
-- --------------------

-- ---------------
-- tourdb_new.part
-- ---------------

-- -----------------
-- tourdb_new.tracks
-- -----------------

-- ---------------------
-- tourdb_new.track_part
-- ---------------------

-- ---------------------
-- tourdb_new.track_wayp
-- ---------------------

-- -------------------
-- tourdb_new.segments
-- -------------------

-- ------------------
-- tourdb_new.sources
-- ------------------
