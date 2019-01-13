import { ErrorMessage, Field, Form, Formik } from "formik";
import { loader } from "graphql.macro";
import React from "react";
import { useMutation, useQuery } from "react-apollo-hooks";
import {
  CreatePositionMutation,
  CreatePositionVariables,
  GetCurrentUserOrgsQuery
} from "../../../../generated/types";
import { absintheToFormikErrors } from "../../../forms/updateFormWithError";

const GET_CURRENT_USER_ORGS_QUERY = loader("./getCurrentUserOrgs.graphql");
const CREATE_POSITION_MUTATION = loader("./createPosition.graphql");

type Props = {
  onFinished: () => void;
};

type PositionFormValues = {
  title: string;
  organizationId: string;
};

class FormikPositionForm extends Formik<PositionFormValues> {}

const PositionForm: React.SFC<Props> = React.memo(function(props) {
  const {
    data: { organizations }
  } = useQuery<GetCurrentUserOrgsQuery>(GET_CURRENT_USER_ORGS_QUERY, {});
  const createPosition = useMutation<
    CreatePositionMutation,
    CreatePositionVariables
  >(CREATE_POSITION_MUTATION);

  return (
    <FormikPositionForm
      initialValues={{ title: "", organizationId: organizations![0].id }}
      onSubmit={async (values, actions) => {
        const organizationId = values.organizationId;
        if (!organizationId) {
          actions.setError(new Error("missing organization id"));
          return;
        }
        const { data } = await createPosition({
          variables: {
            input: {
              organizationId,
              title: values.title
            }
          }
        });
        const messages = data!.createPosition!.messages;
        const successful = data!.createPosition!.successful;
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
          <Field component="select" name="organizationId" id="organizationId">
            {organizations!.map(organization => (
              <option key={organization.id} value={organization.id}>
                {organization.name}
              </option>
            ))}
          </Field>
          <Field type="text" name="title" />
          <ErrorMessage name="title" component="div" />
          <button type="submit" disabled={isSubmitting}>
            Add position
          </button>
        </Form>
      )}
    </FormikPositionForm>
  );
});

export default PositionForm;
