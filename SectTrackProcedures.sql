DROP PROCEDURE IF EXISTS sp_GetAdherentsCountByCult
GO

CREATE PROCEDURE sp_GetAdherentsCountByCult
	AS
	BEGIN
		SELECT COUNT(FK_adherent_id) AS AdherentsCount, FK_sect_id FROM SectAdherent
		GROUP BY FK_sect_id
	END
GO

EXECUTE sp_GetAdherentsCountByCult
GO


DROP PROCEDURE IF EXISTS sp_AssociatedEachAdherentsToEachCult
GO

CREATE PROCEDURE sp_AssociatedEachAdherentsToEachCult
AS
BEGIN 
	DECLARE Adherent_Cursor CURSOR SCROLL FOR
		SELECT FK_adherent_id FROM SectAdherent
	DECLARE @AdherentId INT
	DECLARE Cult_Cursor CURSOR SCROLL FOR
		SELECT sect_id FROM Sect
	DECLARE @SectId INT
	OPEN Adherent_Cursor
	OPEN Cult_Cursor
	FETCH FIRST FROM Adherent_Cursor INTO @AdherentId
	WHILE @@FETCH_STATUS =0
		BEGIN
			FETCH FIRST FROM Cult_Cursor INTO @SectId
			WHILE @@FETCH_STATUS =0
				BEGIN
					INSERT INTO SectAdherent(FK_adherent_id,FK_sect_id) VALUES (@AdherentId,@SectId)
					FETCH NEXT FROM Cult_Cursor INTO @SectId
				END
			FETCH NEXT FROM Adherent_Cursor INTO @AdherentId
		END
	CLOSE Adherent_Cursor
	CLOSE Cult_Cursor
	DEALLOCATE Adherent_Cursor
	DEALLOCATE Cult_Cursor
END
GO

EXECUTE sp_AssociatedEachAdherentsToEachCult
GO

DROP PROCEDURE IF EXISTS sp_GetCultCount
GO

CREATE PROCEDURE sp_GetCultCount
@SectCountOutPut INT OUTPUT
AS
	BEGIN
		SELECT @SectCountOutPut = COUNT(sect_id) FROM Sect
	END
GO

DECLARE @SectCount INT
EXECUTE sp_GetCultCount
	@SectCountOutPut = @SectCount OUTPUT
PRINT @SectCount
GO