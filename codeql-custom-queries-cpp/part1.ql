import cpp

// Print expression class get the expressions
// check if they are +=
// if they are, get rhs side and check if its a call to snprintf
// if it is, get the first argument of snprintf and check if its same as the lhs side of +=

from AssignOperation a, FunctionCall call
where 
  a.getOperator() = "+=" and
  call = a.getRValue() and
  call.getTarget().getName() = "snprintf" and
  a.getLValue().toString() = call.getArgument(0).toString()

select a, "Possible insecure use of snprintf"
