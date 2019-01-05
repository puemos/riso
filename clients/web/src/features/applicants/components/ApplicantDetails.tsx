import gql from "graphql-tag";
import React from "react";
import { useQuery } from "react-apollo-hooks";
import {
  GetApplicantQuery,
  GetApplicantVariables
} from "../../../generated/types";
import ApplicantReviewForm from "./ApplicantReviewForm";

const GET_APPLICANT_QUERY = gql`
  query getApplicant($id: ID!) {
    applicant(id: $id) {
      id
      name
      reviews {
        id
        score
        kpi {
          title
        }
        reviewer {
          name
          email
        }
      }
      position {
        id
        title
        kpis {
          id
          title
        }
      }
      stage {
        title
      }
    }
  }
`;

type Props = {
  id?: string;
};

const ApplicantDetails: React.SFC<Props> = React.memo(props => {
  const { data, errors, loading } = useQuery<
    GetApplicantQuery,
    GetApplicantVariables
  >(GET_APPLICANT_QUERY, {
    suspend: false,
    variables: {
      id: props.id || "0"
    }
  });
  if (loading) {
    return <div>Loading...</div>;
  }
  if (errors) {
    return <div>{`Error! ${errors[0].message}`}</div>;
  }
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
