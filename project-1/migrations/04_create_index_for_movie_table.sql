CREATE INDEX titletsv_index ON movie USING gin(titletsv);
CREATE INDEX categoriestsv_index ON movie USING gin(categoriestsv);
CREATE INDEX summarytsv_index ON movie USING gin(summarytsv);
CREATE INDEX descriptiontsv_index ON movie USING gin(descriptiontsv);