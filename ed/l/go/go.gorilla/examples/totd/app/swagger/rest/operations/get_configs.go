// Code generated by go-swagger; DO NOT EDIT.

package operations

// This file was generated by the swagger tool.
// Editing this file might prove futile when you re-run the generate command

import (
	"net/http"

	"github.com/go-openapi/runtime/middleware"
)

// GetConfigsHandlerFunc turns a function with the right signature into a get configs handler
type GetConfigsHandlerFunc func(GetConfigsParams) middleware.Responder

// Handle executing the request and returning a response
func (fn GetConfigsHandlerFunc) Handle(params GetConfigsParams) middleware.Responder {
	return fn(params)
}

// GetConfigsHandler interface for that can handle valid get configs params
type GetConfigsHandler interface {
	Handle(GetConfigsParams) middleware.Responder
}

// NewGetConfigs creates a new http.Handler for the get configs operation
func NewGetConfigs(ctx *middleware.Context, handler GetConfigsHandler) *GetConfigs {
	return &GetConfigs{Context: ctx, Handler: handler}
}

/* GetConfigs swagger:route GET /clients/{clientId}/mfcs/{mfcId}/configs getConfigs

Get configs.

*/
type GetConfigs struct {
	Context *middleware.Context
	Handler GetConfigsHandler
}

func (o *GetConfigs) ServeHTTP(rw http.ResponseWriter, r *http.Request) {
	route, rCtx, _ := o.Context.RouteInfo(r)
	if rCtx != nil {
		*r = *rCtx
	}
	var Params = NewGetConfigsParams()
	if err := o.Context.BindValidRequest(r, route, &Params); err != nil { // bind params
		o.Context.Respond(rw, r, route.Produces, route, err)
		return
	}

	res := o.Handler.Handle(Params) // actually handle the request
	o.Context.Respond(rw, r, route.Produces, route, res)

}
