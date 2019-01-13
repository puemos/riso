import { ErrorMessage, Field, Form, Formik } from "formik";
import { loader } from "graphql.macro";
import React from "react";
import { useMutation } from "react-apollo-hooks";
import {
  AddApplicantReviewMutation,
  AddApplicantReviewVariables,
  Applicant,
  Kpi
} from "../../../../generated/types";
import { absintheToFormikErrors } from "../../../forms/updateFormWithError";

const ADD_APPLICANT_REVIEW_MUTATION = loader("./addApplicantReview.graphql");

type Props = {
  kpis: Pick<Kpi, "title" | "id">[];
  applicant: Pick<Applicant, "name" | "id">;
  position: Pick<Applicant, "id">;
};

type ApplicantReviewFormValues = {
  score: number;
  kpi: string;
};

class FormikApplicantReviewForm extends Formik<ApplicantReviewFormValues> {}

const ApplicantReviewForm: React.SFC<Props> = React.memo(function(props) {
  const addReview = useMutation<
    AddApplicantReviewMutation,
    AddApplicantReviewVariables
  >(ADD_APPLICANT_REVIEW_MUTATION);
  const { kpis, applicant, position } = props;
  return (
    <FormikApplicantReviewForm
      initialValues={{ score: 0, kpi: kpis[0].id }}
      onSubmit={async (values, actions) => {
        const { data } = await addReview({
          variables: {
            input: {
              applicantId: applicant.id,
              kpiId: values.kpi,
              positionId: position.id,
              score: values.score
            }
          }
        });
        const messages = data!.addApplicantReview.messages;
        const successful = data!.addApplicantReview.successful;
        if (successful) {
          actions.resetForm();
        } else {
          actions.setErrors(absintheToFormikErrors(messages));
        }
        actions.setSubmitting(false);
      }}
    >
      {({ isSubmitting }) => (
        <Form>
          <Field component="select" name="kpi" id="kpi">
            {kpis.map(kpi => (
              <option key={kpi.id} value={kpi.id}>
                {kpi.title}
              </option>
            ))}
          </Field>
          <Field type="number" max={7} min={0} name="score" />
          <ErrorMessage name="score" component="div" />
          <button type="submit" disabled={isSubmitting}>
            Submit review
          </button>
        </Form>
      )}
    </FormikApplicantReviewForm>
  );
});

export default ApplicantReviewForm;
