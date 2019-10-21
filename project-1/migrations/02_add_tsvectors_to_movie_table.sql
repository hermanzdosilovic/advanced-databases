ALTER TABLE movie
ADD COLUMN titletsv TSVector,
ADD COLUMN categoriestsv TSVector,
ADD COLUMN summarytsv TSVector,
ADD COLUMN descriptiontsv TSVector;

UPDATE movie 
SET 
    titletsv = title::TSVector, 
    categoriestsv = categories::TSVector,
    summarytsv = summary::TSVector,
    descriptiontsv = description::TSVector