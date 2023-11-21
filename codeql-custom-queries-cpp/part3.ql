import cpp

from AssignExpr ae, FieldAccess faLHS, FieldAccess faRHS, FunctionCall reallocCall
where
  // LHS of the assignment expression is a field access
  ae.getLValue() = faLHS and

  // RHS of the assignment is a call to realloc
  ae.getRValue() = reallocCall and
  reallocCall.getTarget().getName() = "realloc" and

  // The first argument of realloc is a field access
  reallocCall.getArgument(0) = faRHS and

  // Check if the field of LHS and RHS are the same
  faLHS.getTarget() = faRHS.getTarget() and

  // Check if the qualifier of LHS is the same as the qualifier of RHS
  faLHS.getQualifier().toString() = faRHS.getQualifier().toString()

select ae, "Potential risky realloc pattern involving field: " + faLHS.getTarget().getQualifiedName() + 
         " of struct instance " + faLHS.getQualifier().toString()
