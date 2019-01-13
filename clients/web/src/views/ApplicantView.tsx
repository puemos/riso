import React, { Suspense } from "react";
import ApplicantDetails from "../features/applicants/components/ApplicantDetails";

const ApplicantView: React.SFC<{ path: string; id?: string }> = React.memo(
  function(props) {
    return (
      <div>
        <Suspense fallback="Loading...">
          <ApplicantDetails id={props.id} />
        </Suspense>
      </div>
    );
  }
);

export default ApplicantView;
