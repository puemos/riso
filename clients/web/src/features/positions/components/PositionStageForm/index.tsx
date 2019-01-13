import { ErrorMessage, Field, Form, Formik } from "formik";
import { loader } from "graphql.macro";
import React from "react";
import { useMutation } from "react-apollo-hooks";
import {
  AddPositionStageMutation,
  AddPositionStageVariables
} from "../../../../generated/types";
import { absintheToFormikErrors } from "../../../forms/updateFormWithError";

const ADD_POSITION_STAGE_MUTATION = loader("./addPositionStage.graphql");

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
        const { data } = await createPosition({
          variables: {
            positionId: props.positionId,
            input: {
              title: values.title
            }
          }
        });
        const messages = data!.addPositionStage!.messages;
        const successful = data!.addPositionStage!.successful;
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
