import { loader } from "graphql.macro";
import React from "react";
import { useQuery } from "react-apollo-hooks";
import { GetApplicantQuery, GetApplicantVariables } from "../../../../generated/types";
import ApplicantReviewForm from "../ApplicantReviewForm";

const GET_APPLICANT_QUERY = loader("./getApplicant.graphql");

type Props = {
  id?: string;
};

const ApplicantDetails: React.SFC<Props> = React.memo(props => {
  const { data } = useQuery<GetApplicantQuery, GetApplicantVariables>(
    GET_APPLICANT_QUERY,
    {
      variables: {
        id: props.id || "0"
      }
    }
  );

  const applicant = data!.applicant!;

  return (
    <>
      <h1>{applicant.name}</h1>
      <h2>Current position</h2>
      <h3>{applicant.position!.title}</h3>
      <h2>Reviews</h2>
      <ul>
        {applicant.reviews.map(review => (
          <li key={review.id}>
            {`@${review.reviewer.name}: ${review.kpi.title} ${review.score}`}
          </li>
        ))}
        <li>
          <ApplicantReviewForm
            position={applicant.position!}
            kpis={applicant.position!.kpis!}
            applicant={applicant}
          />
        </li>
      </ul>
    </>
  );
});

export default ApplicantDetails;
