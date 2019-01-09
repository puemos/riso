import { ErrorMessage, Field, Form, Formik } from "formik";
import gql from "graphql-tag";
import React from "react";
import { useMutation } from "react-apollo-hooks";
import {
  AddPositionStageMutation,
  AddPositionStageVariables
} from "../../../generated/types";

const ADD_POSITION_STAGE_MUTATION = gql`
  mutation AddPositionStage($input: PositionStageInput!, $positionId: ID!) {
    addPositionStage(input: $input, positionId: $positionId) {
      successful
    }
  }
`;

type Props = {
  onFinished: () => void;
  positionId: string;
};

type PositionStageFormValues = {
  title: string;
};

class FormikPositionStageForm extends Formik<PositionStageFormValues> {}

const PositionStageForm: React.SFC<Props> = React.memo(function(props) {
  const createPosition = useMutation<
    AddPositionStageMutation,
    AddPositionStageVariables
  >(ADD_POSITION_STAGE_MUTATION);

  return (
    <FormikPositionStageForm
      initialValues={{ title: "" }}
      onSubmit={async (values, actions) => {
        await createPosition({
          variables: {
            positionId: props.positionId,
            input: {
              title: values.title
            }
          }
        });
        props.onFinished();
        actions.setSubmitting(false);
        actions.resetForm();
      }}
    >
      {({ isSubmitting }) => (
        <Form>
          <Field type="text" name="title" />
          <ErrorMessage name="title" component="div" />
          <button type="submit" disabled={isSubmitting}>
            Add stage
          </button>
        </Form>
      )}
    </FormikPositionStageForm>
  );
});

export default PositionStageForm;
