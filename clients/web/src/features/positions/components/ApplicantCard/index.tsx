import { Link } from "@reach/router";
import React from "react";

type Props = {
  id: string;
  name: string;
  photo?: string;
  isDragging: boolean;
};

const getItemStyle = (isDragging: boolean) => ({
  padding: 18 * 2,
  margin: `0 0 ${18}px 0`,
  background: isDragging ? "lightgreen" : "grey"
});

const ApplicantCard: React.SFC<Props> = function(props) {
  const { id, name, photo, isDragging } = props;
  return (
    <div style={getItemStyle(isDragging)}>
      {photo && <img width="30" src={photo} alt="user" />}
      <Link to={`/applicant/${id}`}> {name}</Link>
    </div>
  );
};

export default ApplicantCard;
