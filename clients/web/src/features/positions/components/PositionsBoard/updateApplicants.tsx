import identity from "ramda/es/identity";
import ifElse from "ramda/es/ifElse";
import lensProp from "ramda/es/lensProp";
import map from "ramda/es/map";
import propEq from "ramda/es/propEq";
import set from "ramda/es/set";
import {
  GetPositionApplicants,
  GetPositionStages
} from "../../../../generated/types";

export function updateApplicants(
  applicants: GetPositionApplicants[],
  applicant: GetPositionApplicants,
  positionStage: GetPositionStages
): GetPositionApplicants[] {
  return map(
    ifElse(
      propEq("id", applicant.id),
      set(lensProp("stage"), positionStage),
      identity
    )
  )(applicants);
}
