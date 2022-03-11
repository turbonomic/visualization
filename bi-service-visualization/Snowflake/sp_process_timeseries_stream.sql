create or replace  procedure sp_process_timeseries_stream(SCHEMA string)
    RETURNS STRING
    LANGUAGE JAVASCRIPT
    EXECUTE AS CALLER
    AS
    $$
      let stmt = new Array(3); 
      var result = "";

    stmt[0] =  "insert into " + SCHEMA + ".ENTITIES (oid, time, name, environment, state, type, attrs, tags, numCpus, guestOsName, guestOsType, resource_type, resource_provided, resource_percentage, resource_capacity, resource_consumed, resource_provider_oid, related_type, related_name, related_oid)"
    + " select RECORD_CONTENT:entity.oid::string, RECORD_CONTENT:timestamp::timestamp, RECORD_CONTENT:entity.name::string, RECORD_CONTENT:entity.environment::string, RECORD_CONTENT:entity.state::string, RECORD_CONTENT:entity.type::string, RECORD_CONTENT:entity.attrs::string,"
    + " RECORD_CONTENT:entity.attrs.tags::string, RECORD_CONTENT:entity.attrs.num_cpus::int, RECORD_CONTENT:entity.attrs.guest_os_name::string, RECORD_CONTENT:entity.attrs.guest_os_type::string,"
    + " metric.key::string, metric.value:current::float, metric.value:utilization::float, metric.value:capacity::float, metric.value:consumed::float, metric.value:provider_oid::string, related_array.key::string, related.value:name::string, related.value:oid::string"
    + "  from  " + SCHEMA + ".TIMESERIES_STREAM,"
    + "        table(flatten(RECORD_CONTENT:entity.metric)) metric,"
    + "        table(flatten(RECORD_CONTENT:entity.related)) related_array,"
    + "        lateral flatten(input => related_array.value) related";

    stmt[1] = "insert into " + SCHEMA + ".ACTIONS (oid, time, recommendationTime, type, actionMode, actionState, actionType, actionCategory, severity, description, explanation, savingsPerHour, savingsUnit, target_oid, target_type, target_name, target_affectedMetrics, moveInfo_sourceEntityType, moveInfo_sourceEntityId, moveInfo_sourceEntityName, moveInfo_sourceAffectedMetrics, moveInfo_destinationEntityType, moveInfo_destinationEntityId, moveInfo_destinationEntityName, moveInfo_destinationAffectedMetrics, moveInfo_resourceEntityType, moveInfo_resourceEntityId, moveInfo_resourceEntityName, resizeInfo_commodityType, resizeInfo_targetEntityType, resizeInfo_targetEntityId, resizeInfo_targetEntityName, resizeInfo_newCapacity, resizeInfo_oldCapacity, resizeInfo_unit, resizeInfo_attribute, resizeInfo_percentileBefore, resizeInfo_percentileAfter, resizeInfo_percentileAggressiveness, resizeInfo_percentileObservationPeriodDays, scaleInfo_sourceEntityType, scaleInfo_sourceEntityId, scaleInfo_sourceEntityName, scaleInfo_destinationEntityType, scaleInfo_destinationEntityId, scaleInfo_destinationEntityName, scaleInfo_resourceEntityType, scaleInfo_resourceEntityId, scaleInfo_resourceEntityName, deleteInfo_filePath, deleteInfo_fileSize, deleteInfo_unit, related_type, related_oid, related_name)"
    + " select RECORD_CONTENT:action.oid::string, RECORD_CONTENT:timestamp::timestamp, RECORD_CONTENT:action.creationTime::timestamp, 'ACTION',"
    + " RECORD_CONTENT:action.mode::string, RECORD_CONTENT:action.state::string, RECORD_CONTENT:action.type::string, RECORD_CONTENT:action.category::string,"
    + " RECORD_CONTENT:action.severity::string, RECORD_CONTENT:action.description::string, RECORD_CONTENT:action.explanation::string,"
    + " RECORD_CONTENT:action.savings.amount::float, RECORD_CONTENT:action.savings.unit::string, RECORD_CONTENT:action.target.oid::string, RECORD_CONTENT:action.target.type::string, RECORD_CONTENT:action.target.name::string, RECORD_CONTENT:action.target.affectedMetrics::string,"
    + " RECORD_CONTENT:action.moveInfo.from.type::string, RECORD_CONTENT:action.moveInfo.from.oid::string, RECORD_CONTENT:action.moveInfo.from.name::string, RECORD_CONTENT:action.moveInfo.from.affectedMetrics::string, RECORD_CONTENT:action.moveInfo.to.type::string, RECORD_CONTENT:action.moveInfo.to.oid::string, RECORD_CONTENT:action.moveInfo.to.name::string, RECORD_CONTENT:action.moveInfo.to.affectedMetrics::string, RECORD_CONTENT:action.moveInfo.resource.type::string, RECORD_CONTENT:action.moveInfo.resource.oid::string, RECORD_CONTENT:action.moveInfo.resource.name::string,"
    + " RECORD_CONTENT:action.resizeInfo.commodityType::string, RECORD_CONTENT:action.resizeInfo.target.type::string, RECORD_CONTENT:action.resizeInfo.target.oid::string, RECORD_CONTENT:action.resizeInfo.target.name::string, RECORD_CONTENT:action.resizeInfo.to::float, RECORD_CONTENT:action.resizeInfo.from::float, RECORD_CONTENT:action.resizeInfo.unit::string, RECORD_CONTENT:action.resizeInfo.attribute::string, RECORD_CONTENT:action.resizeInfo.percentileChange.before::float, RECORD_CONTENT:action.resizeInfo.percentileChange.after::float, RECORD_CONTENT:action.resizeInfo.percentileChange.aggressiveness::float, RECORD_CONTENT:action.resizeInfo.percentileChange.observationPeriodDays::float,"
    + " RECORD_CONTENT:action.scaleInfo.from.type::string, RECORD_CONTENT:action.scaleInfo.from.oid::string, RECORD_CONTENT:action.scaleInfo.from.name::string, RECORD_CONTENT:action.scaleInfo.to.type::string, RECORD_CONTENT:action.scaleInfo.to.oid::string, RECORD_CONTENT:action.scaleInfo.to.name::string, RECORD_CONTENT:action.scaleInfo.resource.type::string, RECORD_CONTENT:action.scaleInfo.resource.oid::string, RECORD_CONTENT:action.scaleInfo.resource.name::string, RECORD_CONTENT:action.deleteInfo:filePath::string, RECORD_CONTENT:action.deleteInfo:fileSize::float, RECORD_CONTENT:action.deleteInfo:unit::string, related_array.key::string, related.value:oid::string, related.value:name::string"
    + "  from  " + SCHEMA + ".TIMESERIES_STREAM,"
    + "        table(flatten(RECORD_CONTENT:action.related, outer => true)) related_array,"
    + "        lateral flatten(input => related_array.value, outer => true) related"
    + "        where RECORD_CONTENT:action.oid is not null";

    stmt[2] = "insert into " + SCHEMA + ".BUSINESSACCOUNTS (oid, time, name, environment, state, type, vendorId, expenseTime, expenseName, expenseAmount, expenseUnit)"
    + " select RECORD_CONTENT:entity.oid::string, RECORD_CONTENT:timestamp::timestamp, RECORD_CONTENT:entity.name::string, RECORD_CONTENT:entity.environment::string, RECORD_CONTENT:entity.state::string, RECORD_CONTENT:entity.type::string,"
    + " RECORD_CONTENT:entity:attrs.targets[0].entityVendorId::string, RECORD_CONTENT:entity.accountExpenses:expenseDate::timestamp, expenses.key::string, expenses.value:amount::float, expenses.value:unit::string"
    + "  from  " + SCHEMA + ".TIMESERIES_STREAM,"
    + "        table(flatten(RECORD_CONTENT:entity.accountExpenses.serviceExpenses)) expenses"
    + "        where RECORD_CONTENT:entity.type = 'BUSINESS_ACCOUNT' and expenses.value:amount > 0";

    snowflake.execute( {sqlText: "BEGIN WORK;"});
      try {
           for(i=0; i<stmt.length; i++) {
                snowflake.execute( {sqlText: stmt[i]});
           }
     
          snowflake.execute( {sqlText: "COMMIT WORK;"});
          result = "succeeded";
      }
      catch (err) {
          snowflake.execute( {sqlText: "ROLLBACK WORK;"} );
          result = stmt[i];
      }  
    return result;
    $$;
