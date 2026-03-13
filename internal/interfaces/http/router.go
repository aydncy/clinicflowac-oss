import (
"clinicflow/internal/application/service"
"clinicflow/internal/interfaces/http/handler"
)

// ---- VERIFY ENDPOINT ----

pubKey, _ := keyManager.PublicJWK()

verifyService := service.NewTokenVerifyService(pubKey)
verifyHandler := handler.NewTokenVerifyHandler(verifyService)

v1.POST("/token/verify", verifyHandler.Verify)

// ---- END VERIFY ----
