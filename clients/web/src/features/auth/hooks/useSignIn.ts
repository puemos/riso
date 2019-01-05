import gql from "graphql-tag";
import { useMutation } from "react-apollo-hooks";
import { SignInMutation, SignInVariables } from "../../../generated/types";
import { useReduxAction } from "../../../redux/hooks/use-redux-action";
import { AuthActions } from "../actions";

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
  const loggedIn = useReduxAction(AuthActions.loggedIn);
  const loggedOut = useReduxAction(AuthActions.loggedOut);
  const signIn = async (variables: SignInVariables) => {
    const { data } = await mutation({ variables });
    if (data!.signIn!.result) {
      localStorage.setItem("token", data!.signIn!.result!.token);
      loggedIn();
      return true;
    } else {
      localStorage.removeItem("token");
      loggedOut();
      return false;
    }
  };
  return signIn;
}
