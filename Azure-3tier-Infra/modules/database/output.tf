output "id" {
  value       = azurerm_key_vault.db-keyvault.id
  description = "The ID of the Key Vault."
}

output "azurerm_mssql_server.id" {
  value       = azurerm_key_vault.db-keyvault.id
  description = "The ID of MSSQL."
  
}