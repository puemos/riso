import { ErrorMessage, Field, Form, Formik } from "formik";
import { loader } from "graphql.macro";
import React from "react";
import { useMutation } from "react-apollo-hooks";
import {
  CreateApplicantMutation,
  CreateApplicantVariables
} from "../../../../generated/types";
import { absintheToFormikErrors } from "../../../forms/updateFormWithError";

const CREATE_APPLICANT_MUTATION = loader("./createApplicant.graphql");

type Props = {
  positionId?: string;
  onFinished: () => void;
};

type ApplicantFormValues = {
  name: string;
  positionId?: string;
};

class FormikApplicantForm extends Formik<ApplicantFormValues> {}

const ApplicantForm: React.SFC<Props> = React.memo(function(props) {
  const createApplicant = useMutation<
    CreateApplicantMutation,
    CreateApplicantVariables
  >(CREATE_APPLICANT_MUTATION);
  return (
    <FormikApplicantForm
      initialValues={{ name: "" }}
      onSubmit={async (values, actions) => {
        const positionId = values.positionId || props.positionId;
        if (!positionId) {
          actions.setError(new Error("missing position id"));
          return;
        }
        const { data } = await createApplicant({
          variables: {
            input: {
              name: values.name,
              positionId
            }
          }
        });
        const messages = data!.createApplicant.messages;
        const successful = data!.createApplicant.successful;
        if (successful) {
          actions.resetForm();
          props.onFinished();
        } else {
          actions.setErrors(absintheToFormikErrors(messages));
        }
        actions.setSubmitting(false);
      }}
    >
      {({ isSubmitting }) => (
        <Form>
          <Field type="text" name="name" />
          <ErrorMessage name="name" component="div" />
          <button type="submit" disabled={isSubmitting}>
            Add applicant
          </button>
        </Form>
      )}
    </FormikApplicantForm>
  );
});

export default ApplicantForm;
