-- =====================
-- == Check migration ==
-- =====================

-- types (old)
SELECT 
	tourdb_prod.tbl_types.typCode,
	tourdb_prod.tbl_types.typName,
	ptype.typCode,
	tourdb_prod.tbl_types.typPurpose
FROM tourdb_prod.tbl_types
left OUTER JOIN tourdb_prod.tbl_types ptype ON tourdb_prod.tbl_types.typParentId = ptype.typId
ORDER BY tourdb_prod.tbl_types.typCode, ptype.typCode;

-- types (new)
SELECT 
	tourdb_new.types.code,
	tourdb_new.types.name,
	ptype.code,
	types.usage
FROM tourdb_new.types
left outer JOIN tourdb_new.types ptype ON tourdb_new.types.fk_parentId = ptype.typeId
ORDER BY tourdb_new.types.code, ptype.code;

