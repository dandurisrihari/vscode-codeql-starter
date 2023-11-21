import cpp
import semmle.code.cpp.dataflow.TaintTracking

/**
 * Taint tracking configuration for tracing data from 'scanf' inputs to 'malloc' arguments.
 */
class ScanfToMallocTaintConfig extends TaintTracking::Configuration {
  ScanfToMallocTaintConfig() { this = "ScanfToMallocTaintConfig" }

  /**
   * Source of taint: Variables whose addresses are passed to 'scanf'.
   */
  override predicate isSource(DataFlow::Node source) {
    exists(FunctionCall scanfCall, int i |
      scanfCall.getTarget().hasGlobalName("scanf") and
      // Consider arguments other than the format string as sources
      i > 0 and
      source.asDefiningArgument() = scanfCall.getArgument(i)
    )
  }

  /**
   * Sink: The operands in a multiplication expression used as an argument in 'malloc'.
   */
  override predicate isSink(DataFlow::Node sink) {
    exists(MulExpr mulExpr, FunctionCall mallocCall |
      mallocCall.getTarget().hasGlobalName("malloc") and
      mallocCall.getArgument(0) = mulExpr and
      (sink.asExpr() = mulExpr.getLeftOperand() or
       sink.asExpr() = mulExpr.getRightOperand())
    )
  }
}

from ScanfToMallocTaintConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink, source, sink.getNode(), "The size argument of malloc uses a multiplication potentially tainted by scanf."
