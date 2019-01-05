import { ErrorMessage, Field, Form, Formik } from "formik";
import gql from "graphql-tag";
import React from "react";
import { useMutation } from "react-apollo-hooks";
import {
  CreateApplicantMutation,
  CreateApplicantVariables
} from "../../../generated/types";

const CREATE_APPLICANT_MUTATION = gql`
  mutation CreateApplicant($input: ApplicantInput!) {
    createApplicant(input: $input) {
      successful
    }
  }
`;

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
        await createApplicant({
          variables: {
            input: {
              name: values.name,
              positionId
            }
          }
        });
        props.onFinished();
        actions.setSubmitting(false);
      }}
    >
      {({ isSubmitting }) => (
        <Form>
          <Field type="text" name="name" />
          <ErrorMessage name="score" component="div" />
          <button type="submit" disabled={isSubmitting}>
            Submit
          </button>
        </Form>
      )}
    </FormikApplicantForm>
  );
});

export default ApplicantForm;
