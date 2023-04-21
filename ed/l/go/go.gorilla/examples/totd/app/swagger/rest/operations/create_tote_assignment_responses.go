// Code generated by go-swagger; DO NOT EDIT.

package operations

// This file was generated by the swagger tool.
// Editing this file might prove futile when you re-run the swagger generate command

import (
	"net/http"

	"github.com/go-openapi/runtime"

	"github.com/to-com/poc-td/app/swagger/restmodel"
)

// CreateToteAssignmentOKCode is the HTTP code returned for type CreateToteAssignmentOK
const CreateToteAssignmentOKCode int = 200

/*CreateToteAssignmentOK Successful response.

swagger:response createToteAssignmentOK
*/
type CreateToteAssignmentOK struct {

	/*
	  In: Body
	*/
	Payload *restmodel.CreateToteAssignmentResponse `json:"body,omitempty"`
}

// NewCreateToteAssignmentOK creates CreateToteAssignmentOK with default headers values
func NewCreateToteAssignmentOK() *CreateToteAssignmentOK {

	return &CreateToteAssignmentOK{}
}

// WithPayload adds the payload to the create tote assignment o k response
func (o *CreateToteAssignmentOK) WithPayload(payload *restmodel.CreateToteAssignmentResponse) *CreateToteAssignmentOK {
	o.Payload = payload
	return o
}

// SetPayload sets the payload to the create tote assignment o k response
func (o *CreateToteAssignmentOK) SetPayload(payload *restmodel.CreateToteAssignmentResponse) {
	o.Payload = payload
}

// WriteResponse to the client
func (o *CreateToteAssignmentOK) WriteResponse(rw http.ResponseWriter, producer runtime.Producer) {

	rw.WriteHeader(200)
	if o.Payload != nil {
		payload := o.Payload
		if err := producer.Produce(rw, payload); err != nil {
			panic(err) // let the recovery middleware deal with this
		}
	}
}

// CreateToteAssignmentBadRequestCode is the HTTP code returned for type CreateToteAssignmentBadRequest
const CreateToteAssignmentBadRequestCode int = 400

/*CreateToteAssignmentBadRequest Bad Request.

swagger:response createToteAssignmentBadRequest
*/
type CreateToteAssignmentBadRequest struct {

	/*
	  In: Body
	*/
	Payload *restmodel.Response400 `json:"body,omitempty"`
}

// NewCreateToteAssignmentBadRequest creates CreateToteAssignmentBadRequest with default headers values
func NewCreateToteAssignmentBadRequest() *CreateToteAssignmentBadRequest {

	return &CreateToteAssignmentBadRequest{}
}

// WithPayload adds the payload to the create tote assignment bad request response
func (o *CreateToteAssignmentBadRequest) WithPayload(payload *restmodel.Response400) *CreateToteAssignmentBadRequest {
	o.Payload = payload
	return o
}

// SetPayload sets the payload to the create tote assignment bad request response
func (o *CreateToteAssignmentBadRequest) SetPayload(payload *restmodel.Response400) {
	o.Payload = payload
}

// WriteResponse to the client
func (o *CreateToteAssignmentBadRequest) WriteResponse(rw http.ResponseWriter, producer runtime.Producer) {

	rw.WriteHeader(400)
	if o.Payload != nil {
		payload := o.Payload
		if err := producer.Produce(rw, payload); err != nil {
			panic(err) // let the recovery middleware deal with this
		}
	}
}
