import React from "react";
import { GetPositionApplicants } from "../../../generated/types";
import { DraggableStateSnapshot } from "react-beautiful-dnd";
import { Link } from "@reach/router";

type Props = {
  applicant: GetPositionApplicants;
  snapshot?: DraggableStateSnapshot;
};

const ApplicantCard: React.SFC<Props> = function(props) {
  const { applicant } = props;
  return (
    <div>
      {applicant.photo && <img width="60" src={applicant.photo} alt="user" />}
      {applicant.name}
      <Link to={`/applicant/${applicant.id}`}>{applicant.id}</Link>
    </div>
  );
};

export default ApplicantCard;
