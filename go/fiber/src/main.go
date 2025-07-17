package main

import (
	"os"

	"github.com/gofiber/fiber/v2"
)

type StatusResponse struct {
	Status string `json:"status"`
}

func getUser(c *fiber.Ctx) error {
	return c.JSON(StatusResponse{Status: "success"})
}

func healthcheck(c *fiber.Ctx) error {
	return c.JSON(StatusResponse{Status: "success"})
}

func main() {
	app := fiber.New()
	
	// Get PREFIX environment variable
	prefix := os.Getenv("PREFIX")
	
	// Create route group with prefix
	var routeGroup fiber.Router
	if prefix != "" {
		routeGroup = app.Group(prefix)
	} else {
		routeGroup = app
	}
	
	// Define routes
	routeGroup.Get("/user", getUser)
	routeGroup.Get("/healthcheck", healthcheck)
	
	// Start server on port 8080
	app.Listen(":8080")
}