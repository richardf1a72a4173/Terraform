# # Create container image
# resource "docker_image" "init_app" {
#   name         = "${data.azurerm_container_registry.myacr.login_server}/image${local.resource_template}001"
#   keep_locally = true

#   build {
#     no_cache = true
#     context  = "${path.cwd}/init-app"
#   }

#   triggers = {
#     dir_sha1 = sha1(join("", [for f in fileset(path.cwd, "init-app/*") : filesha1(f)]))
#   }

#   depends_on = [data.azurerm_container_registry.myacr]
# }

# # Push container image to ACR
# resource "docker_registry_image" "push_image_to_acr" {
#   name          = docker_image.init_app.name
#   keep_remotely = true

#   triggers = {
#     dir_sha1 = sha1(join("", [for f in fileset(path.cwd, "init-app/*") : filesha1(f)]))
#   }

#   depends_on = [data.azurerm_container_registry.myacr]
# }
