import { FormikErrors } from "formik";
import filter from "ramda/es/filter";
import isNil from "ramda/es/isNil";
import map from "ramda/es/map";
import reduce from "ramda/es/reduce";
import { pipe } from "rxjs";

type AbsintheErrorMessage = {
  field: Maybe<string>;
  message: Maybe<string>;
};

export function absintheToFormikErrors<V>(
  messages: Maybe<AbsintheErrorMessage[]>
): FormikErrors<V> {
  if (!messages) {
    return {};
  }
  return pipe(
    filter(({ field, message }) => !isNil(field) && !isNil(message)),
    map(({ field, message }) => ({ [field]: message })),
    reduce((errors, msg) => ({ ...errors, ...msg }), {})
  )(messages);
}
