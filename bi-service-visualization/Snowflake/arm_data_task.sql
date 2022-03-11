-- create fixed tables for each timeseries data type replacing less efficient views

ALTER VIEW ARM.T8CSECTRLLAB.ENTITIES RENAME TO ARM.T8CSECTRLLAB.ENTITIES_VIEW;
create or replace table ARM.T8CSECTRLLAB.ENTITIES as
select RECORD_CONTENT:entity.oid::string as oid, RECORD_CONTENT:timestamp::timestamp as time, RECORD_CONTENT:entity.name::string as name, RECORD_CONTENT:entity.environment::string as environment, RECORD_CONTENT:entity.state::string as state, RECORD_CONTENT:entity.type::string as type, RECORD_CONTENT:entity.attrs::string as attrs,
    RECORD_CONTENT:entity.attrs.tags::string as tags,
    RECORD_CONTENT:entity.attrs.num_cpus::int as numCpus,
    RECORD_CONTENT:entity.attrs.guest_os_name::string as guestOsName,
    RECORD_CONTENT:entity.attrs.guest_os_type::string as guestOsType,
    metric.key::string as resource_type,
	metric.value:current::float as resource_provided,
	metric.value:utilization::float as resource_percentage,
	metric.value:capacity::float as resource_capacity,
	metric.value:consumed::float as resource_consumed,
	metric.value:provider_oid::float as resource_provider_oid,
	related_array.key::string as related_type,
	related.value:oid::string as related_oid,
	related.value:name::string as related_name
from ARM.T8CSECTRLLAB.TIMESERIES,
	table(flatten(RECORD_CONTENT:entity.metric)) metric,
	table(flatten(RECORD_CONTENT:entity.related)) related_array,
	lateral flatten(input => related_array.value) related;

ALTER VIEW ARM.T8CSECTRLLAB.ACTIONS RENAME TO ARM.T8CSECTRLLAB.ACTIONS_VIEW;
create or replace table ARM.T8CSECTRLLAB.ACTIONS as
select RECORD_CONTENT:action.oid::string as oid, RECORD_CONTENT:timestamp::timestamp as time, RECORD_CONTENT:action.creationTime::timestamp as recommendationTime, 'ACTION' as type,
	RECORD_CONTENT:action.mode::string as actionMode, RECORD_CONTENT:action.state::string as actionState, RECORD_CONTENT:action.type::string as actionType, RECORD_CONTENT:action.category::string as actionCategory,
    RECORD_CONTENT:action.severity::string as severity, RECORD_CONTENT:action.description::string as description, RECORD_CONTENT:action.explanation::string as explanation,
	RECORD_CONTENT:action.savings.amount::float as savingsPerHour,
	RECORD_CONTENT:action.savings.unit::string as savingsUnit,
	RECORD_CONTENT:action.target.type::string as target_type,
	RECORD_CONTENT:action.target.oid::string as target_oid,
	RECORD_CONTENT:action.target.name::string as target_name,
	RECORD_CONTENT:action.target.affectedMetrics::string as target_affectedMetrics,
	RECORD_CONTENT:action.moveInfo.from.type::string as moveInfo_sourceEntityType,
	RECORD_CONTENT:action.moveInfo.from.oid::string as moveInfo_sourceEntityId,
	RECORD_CONTENT:action.moveInfo.from.name::string as moveInfo_sourceEntityName,
	RECORD_CONTENT:action.moveInfo.from.affectedMetrics::string as moveInfo_sourceAffectedMetrics,
	RECORD_CONTENT:action.moveInfo.to.type::string as moveInfo_destinationEntityType,
	RECORD_CONTENT:action.moveInfo.to.oid::string as moveInfo_destinationEntityId,
	RECORD_CONTENT:action.moveInfo.to.name::string as moveInfo_destinationEntityName,
	RECORD_CONTENT:action.moveInfo.to.affectedMetrics::string as moveInfo_destinationAffectedMetrics,
	RECORD_CONTENT:action.moveInfo.resource.type::string as moveInfo_resourceEntityType,
	RECORD_CONTENT:action.moveInfo.resource.oid::string as moveInfo_resourceEntityId,
	RECORD_CONTENT:action.moveInfo.resource.name::string as moveInfo_resourceEntityName,
    RECORD_CONTENT:action.resizeInfo.commodityType::string as resizeInfo_commodityType,
	RECORD_CONTENT:action.resizeInfo.target.type::string as resizeInfo_targetEntityType,
    RECORD_CONTENT:action.resizeInfo.target.oid::string as resizeInfo_targetEntityId,
    RECORD_CONTENT:action.resizeInfo.target.name::string as resizeInfo_targetEntityName,
	RECORD_CONTENT:action.resizeInfo.to::float as resizeInfo_newCapacity,
	RECORD_CONTENT:action.resizeInfo.from::float as resizeInfo_oldCapacity,
	RECORD_CONTENT:action.resizeInfo.unit::string as resizeInfo_unit,
	RECORD_CONTENT:action.resizeInfo.attribute::string as resizeInfo_attribute,
	RECORD_CONTENT:action.resizeInfo.percentileChange.before::float as resizeInfo_percentileBefore,
	RECORD_CONTENT:action.resizeInfo.percentileChange.after::float as resizeInfo_percentileAfter,
	RECORD_CONTENT:action.resizeInfo.percentileChange.aggressiveness::float as resizeInfo_percentileAggressiveness,
	RECORD_CONTENT:action.resizeInfo.percentileChange.observationPeriodDays::float as resizeInfo_percentileObservationPeriodDays,
	RECORD_CONTENT:action.scaleInfo.from.type::string as scaleInfo_sourceEntityType,
	RECORD_CONTENT:action.scaleInfo.from.oid::string as scaleInfo_sourceEntityId,
	RECORD_CONTENT:action.scaleInfo.from.name::string as scaleInfo_sourceEntityName,
	RECORD_CONTENT:action.scaleInfo.to.type::string as scaleInfo_destinationEntityType,
	RECORD_CONTENT:action.scaleInfo.to.oid::string as scaleInfo_destinationEntityId,
	RECORD_CONTENT:action.scaleInfo.to.name::string as scaleInfo_destinationEntityName,
	RECORD_CONTENT:action.scaleInfo.resource.type::string as scaleInfo_resourceEntityType,
	RECORD_CONTENT:action.scaleInfo.resource.oid::string as scaleInfo_resourceEntityId,
	RECORD_CONTENT:action.scaleInfo.resource.name::string as scaleInfo_resourceEntityName,
	RECORD_CONTENT:action.deleteInfo:filePath::string as deleteInfo_filePath,
	RECORD_CONTENT:action.deleteInfo:fileSize::float as deleteInfo_fileSize,
	RECORD_CONTENT:action.deleteInfo:unit::string as deleteInfo_unit,
	related_array.key::string as related_type,
	related.value:oid::string as related_oid,
	related.value:name::string as related_name
 from ARM.T8CSECTRLLAB.TIMESERIES,
	table(flatten(RECORD_CONTENT:action.related, outer => true)) related_array,
	lateral flatten(input => related_array.value, outer => true) related
    where RECORD_CONTENT:action.oid is not null;

create or replace table ARM.T8CSECTRLLAB.ACTIONS_RELATED as
select RECORD_CONTENT:action.oid::string as oid, RECORD_CONTENT:timestamp::timestamp as time, RECORD_CONTENT:action.creationTime::timestamp as recommendationTime, 'ACTION' as type,
	RECORD_CONTENT:action.mode::string as actionMode, RECORD_CONTENT:action.state::string as actionState, RECORD_CONTENT:action.type::string as actionType, RECORD_CONTENT:action.category::string as actionCategory,
    RECORD_CONTENT:action.severity::string as severity, RECORD_CONTENT:action.description::string as description, RECORD_CONTENT:action.explanation::string as explanation,
	RECORD_CONTENT:action.savings.amount::float as savingsPerHour,
	RECORD_CONTENT:action.savings.unit::string as savingsUnit,
	RECORD_CONTENT:action.target.type::string as target_type,
	RECORD_CONTENT:action.target.oid::string as target_oid,
	RECORD_CONTENT:action.target.name::string as target_name,
	RECORD_CONTENT:action.target.affectedMetrics::string as target_affectedMetrics,
	RECORD_CONTENT:action.moveInfo.from.type::string as moveInfo_sourceEntityType,
	RECORD_CONTENT:action.moveInfo.from.oid::string as moveInfo_sourceEntityId,
	RECORD_CONTENT:action.moveInfo.from.name::string as moveInfo_sourceEntityName,
	RECORD_CONTENT:action.moveInfo.from.affectedMetrics::string as moveInfo_sourceAffectedMetrics,
	RECORD_CONTENT:action.moveInfo.to.type::string as moveInfo_destinationEntityType,
	RECORD_CONTENT:action.moveInfo.to.oid::string as moveInfo_destinationEntityId,
	RECORD_CONTENT:action.moveInfo.to.name::string as moveInfo_destinationEntityName,
	RECORD_CONTENT:action.moveInfo.to.affectedMetrics::string as moveInfo_destinationAffectedMetrics,
	RECORD_CONTENT:action.moveInfo.resource.type::string as moveInfo_resourceEntityType,
	RECORD_CONTENT:action.moveInfo.resource.oid::string as moveInfo_resourceEntityId,
	RECORD_CONTENT:action.moveInfo.resource.name::string as moveInfo_resourceEntityName,
    RECORD_CONTENT:action.resizeInfo.commodityType::string as resizeInfo_commodityType,
	RECORD_CONTENT:action.resizeInfo.target.type::string as resizeInfo_targetEntityType,
    RECORD_CONTENT:action.resizeInfo.target.oid::string as resizeInfo_targetEntityId,
    RECORD_CONTENT:action.resizeInfo.target.name::string as resizeInfo_targetEntityName,
	RECORD_CONTENT:action.resizeInfo.to::float as resizeInfo_newCapacity,
	RECORD_CONTENT:action.resizeInfo.from::float as resizeInfo_oldCapacity,
	RECORD_CONTENT:action.resizeInfo.unit::string as resizeInfo_unit,
	RECORD_CONTENT:action.resizeInfo.attribute::string as resizeInfo_attribute,
	RECORD_CONTENT:action.resizeInfo.percentileChange.before::float as resizeInfo_percentileBefore,
	RECORD_CONTENT:action.resizeInfo.percentileChange.after::float as resizeInfo_percentileAfter,
	RECORD_CONTENT:action.resizeInfo.percentileChange.aggressiveness::float as resizeInfo_percentileAggressiveness,
	RECORD_CONTENT:action.resizeInfo.percentileChange.observationPeriodDays::float as resizeInfo_percentileObservationPeriodDays,
	RECORD_CONTENT:action.scaleInfo.from.type::string as scaleInfo_sourceEntityType,
	RECORD_CONTENT:action.scaleInfo.from.oid::string as scaleInfo_sourceEntityId,
	RECORD_CONTENT:action.scaleInfo.from.name::string as scaleInfo_sourceEntityName,
	RECORD_CONTENT:action.scaleInfo.to.type::string as scaleInfo_destinationEntityType,
	RECORD_CONTENT:action.scaleInfo.to.oid::string as scaleInfo_destinationEntityId,
	RECORD_CONTENT:action.scaleInfo.to.name::string as scaleInfo_destinationEntityName,
	RECORD_CONTENT:action.scaleInfo.resource.type::string as scaleInfo_resourceEntityType,
	RECORD_CONTENT:action.scaleInfo.resource.oid::string as scaleInfo_resourceEntityId,
	RECORD_CONTENT:action.scaleInfo.resource.name::string as scaleInfo_resourceEntityName,
	RECORD_CONTENT:action.deleteInfo:filePath::string as deleteInfo_filePath,
	RECORD_CONTENT:action.deleteInfo:fileSize::float as deleteInfo_fileSize,
	RECORD_CONTENT:action.deleteInfo:unit::string as deleteInfo_unit,
	RECORD_CONTENT:action.related::string as related
 from ARM.T8CSECTRLLAB.TIMESERIES
    where RECORD_CONTENT:action.oid is not null;

ALTER VIEW ARM.T8CSECTRLLAB.BUSINESSACCOUNTS RENAME TO ARM.T8CSECTRLLAB.BUSINESSACCOUNTS_VIEW;
create or replace table ARM.T8CSECTRLLAB.BUSINESSACCOUNTS as
select RECORD_CONTENT:entity.oid::string as oid, RECORD_CONTENT:timestamp::timestamp as time, RECORD_CONTENT:entity.name::string as name, RECORD_CONTENT:entity.environment::string as environment, RECORD_CONTENT:entity.state::string as state, RECORD_CONTENT:entity.type::string as type,
    RECORD_CONTENT:entity:attrs.vendor_id::string as vendorId,
    RECORD_CONTENT:entity.accountExpenses:expenseDate::timestamp as expenseTime,
    expenses.key::string as expenseName,
    expenses.value:amount::float as expenseAmount,
    expenses.value:unit::string as expenseUnit
from ARM.T8CSECTRLLAB.TIMESERIES,
    table(flatten(RECORD_CONTENT:entity.accountExpenses.serviceExpenses)) expenses
	where type = 'BUSINESS_ACCOUNT' and expenseAmount > 0;

create or replace stream ARM.T8CSECTRLLAB.timeseries_stream on table ARM.T8CSECTRLLAB.timeseries;

create or replace task ARM.T8CSECTRLLAB.process_timeseries_stream
warehouse = task_wh
SCHEDULE = '1 minute'
when SYSTEM$STREAM_HAS_DATA('ARM.T8CSECTRLLAB.TIMESERIES_STREAM')
as
call ARM.T8CSECTRLLAB.sp_process_timeseries_stream('ARM.T8CSECTRLLAB');

alter task ARM.T8CSECTRLLAB.process_timeseries_stream resume;
