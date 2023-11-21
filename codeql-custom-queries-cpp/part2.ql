import cpp

from FunctionCall call
where
  (
    call.getTarget().getName() = "sprintf" or
    call.getTarget().getName() = "sscanf" or
    call.getTarget().getName() = "fscanf"
  ) and
  exists(string formatString | formatString = call.getArgument(1).getValue() |
    formatString.regexpMatch(".*%s.*")
  )
select call, "This call to " + call.getTarget().getName() + " with a '%s' format string might be dangerous."
