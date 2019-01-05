import React from "react";
import ApplicantDetails from "../features/applicants/components/ApplicantDetails";

const ApplicantView: React.SFC<{ path: string; id?: string }> = React.memo(
  function(props) {
    return (
      <div>
        <ApplicantDetails id={props.id} />
      </div>
    );
  }
);

export default ApplicantView;
