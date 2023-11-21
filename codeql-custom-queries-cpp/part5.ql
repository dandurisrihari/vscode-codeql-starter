import cpp
import semmle.code.cpp.dataflow.TaintTracking

class DoubleFreeConfig extends TaintTracking::Configuration {
  DoubleFreeConfig() { this = "DoubleFreeConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(FunctionCall freeCall |
      freeCall.getTarget().hasGlobalName("free") and
      source.asDefiningArgument() = freeCall.getArgument(0)
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall freeCall |
      freeCall.getTarget().hasGlobalName("free") and
      sink.asExpr() = freeCall.getArgument(0)
    )
  }

  // New predicate to check for reassignments
  predicate isReassignedBetween(DataFlow::Node source, DataFlow::Node sink) {
    exists(Assignment assign |
      assign.getLValue().(VariableAccess).getTarget() = source.asExpr().(VariableAccess).getTarget() and
      source.getLocation().getEndLine() < assign.getLocation().getStartLine() and
      assign.getLocation().getEndLine() < sink.getLocation().getStartLine()
    )
  }

}

from DoubleFreeConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink) and
      // The source and sink must be different
      source.getNode() != sink.getNode() and
      // Ensure the pointer is not reassigned between the two free calls
      not config.isReassignedBetween(source.getNode(), sink.getNode())

select sink.getNode(), source, sink, "Double free"