output "budget_name" {
    description = "Budget name"
    value = aws_budgets_budget.services_utilization.name
  
}

output "budget_arn" {
    description = "Budget arn"
    value = aws_budgets_budget.services_utilization.arn
  
}

output "budget_id" {
    description = "Budget Id"
    value = aws_budgets_budget.services_utilization.id
  
}