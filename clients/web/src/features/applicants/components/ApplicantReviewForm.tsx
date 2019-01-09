import React from "react";
import {
  Kpi,
  Applicant,
  AddApplicantReviewMutation,
  AddApplicantReviewVariables
} from "../../../generated/types";
import { Formik, Field, ErrorMessage, Form } from "formik";
import gql from "graphql-tag";
import { useMutation } from "react-apollo-hooks";

const ADD_APPLICANT_REVIEW_MUTATION = gql`
  mutation AddApplicantReview($input: ApplicantReviewInput!) {
    addApplicantReview(input: $input) {
      successful
    }
  }
`;

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
        await addReview({
          variables: {
            input: {
              applicantId: applicant.id,
              kpiId: values.kpi,
              positionId: position.id,
              score: values.score
            }
          }
        });
        actions.setSubmitting(false);
        actions.resetForm();
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
