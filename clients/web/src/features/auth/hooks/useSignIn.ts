import gql from "graphql-tag";
import { useMutation } from "react-apollo-hooks";
import store from "../../../store/store";
import { AuthActions } from "../actions";
import { SignInMutation, SignInVariables } from "../../../generated/types";

const SIGNIN_MUTATION = gql`
  mutation signIn($input: SignInInput!) {
    signIn(input: $input) {
      result {
        token
      }
    }
  }
`;

export default function useSignIn() {
  const mutation = useMutation<SignInMutation, SignInVariables>(
    SIGNIN_MUTATION
  );
  const signIn = async (variables: SignInVariables) => {
    const { data } = await mutation({ variables });
    if (data!.signIn!.result) {
      localStorage.setItem("token", data!.signIn!.result!.token);
      store.dispatch(AuthActions.loggedIn());
      return true;
    } else {
      localStorage.removeItem("token");
      store.dispatch(AuthActions.loggedOut());
      return false;
    }
  };
  return signIn;
}
