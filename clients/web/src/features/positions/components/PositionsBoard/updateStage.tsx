import complement from "ramda/es/complement";
import filter from "ramda/es/filter";
import identity from "ramda/es/identity";
import ifElse from "ramda/es/ifElse";
import insert from "ramda/es/insert";
import lensProp from "ramda/es/lensProp";
import map from "ramda/es/map";
import over from "ramda/es/over";
import propEq from "ramda/es/propEq";
import propOr from "ramda/es/propOr";
import { pipe } from "rxjs";
import {
  GetPositionApplicants,
  GetPositionStages
} from "../../../../generated/types";

export function updateStage(
  stages: GetPositionStages[],
  applicant: GetPositionApplicants,
  positionStage: GetPositionStages,
  index: number
): GetPositionStages[] {
  return pipe(
    map(
      over(
        lensProp("applicants"),
        filter(complement(propEq("id", applicant.id)))
      )
    ),
    map(
      ifElse(
        propEq("id", propOr("", "id", positionStage)),
        over(lensProp("applicants"), insert(index, applicant)),
        identity
      )
    )
  )(stages);
}
