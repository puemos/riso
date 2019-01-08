import { ErrorMessage, Field, Form, Formik } from "formik";
import gql from "graphql-tag";
import React from "react";
import { useMutation, useQuery } from "react-apollo-hooks";
import {
  CreatePositionMutation,
  CreatePositionVariables,
  GetCurrentUserOrgsQuery
} from "../../../generated/types";

const GET_CURRENT_USER_ORGS_QUERY = gql`
  query getCurrentUserOrgs {
    organizations {
      id
      name
    }
  }
`;

const CREATE_POSITION_MUTATION = gql`
  mutation CreatePosition($input: PositionInput!) {
    createPosition(input: $input) {
      successful
    }
  }
`;

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
    data: { organizations },
    errors,
    loading,
    refetch
  } = useQuery<GetCurrentUserOrgsQuery>(GET_CURRENT_USER_ORGS_QUERY, {
    suspend: false
  });
  const createPosition = useMutation<
    CreatePositionMutation,
    CreatePositionVariables
  >(CREATE_POSITION_MUTATION);

  if (errors) {
    return <div>{`Error! ${errors[0].message}`}</div>;
  }
  if (loading) {
    return <div>Loading...</div>;
  }

  return (
    <FormikPositionForm
      initialValues={{ title: "", organizationId: organizations![0].id }}
      onSubmit={async (values, actions) => {
        const organizationId = values.organizationId;
        if (!organizationId) {
          actions.setError(new Error("missing organization id"));
          return;
        }
        await createPosition({
          variables: {
            input: {
              organizationId,
              title: values.title
            }
          }
        });
        props.onFinished();
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
            Add
          </button>
        </Form>
      )}
    </FormikPositionForm>
  );
});

export default PositionForm;
