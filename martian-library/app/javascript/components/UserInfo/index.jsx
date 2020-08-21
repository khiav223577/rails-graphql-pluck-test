import React, { useRef } from "react";
import { Query, Mutation } from "react-apollo";
import { Me, SignMeIn, SignMeOut } from "./operations.graphql";
import cs from "./styles";

const UserInfo = () => {
  const input = useRef(null);

  return (
    <div className={cs.panel}>
      <Query query={Me}>
        {({ data, loading }) => {
          if (loading) return "...Loading";
          if (!data.me) {
            return (
              <Mutation
                mutation={SignMeIn}
                update={(cache, { data: { signIn } }) => {
                  cache.writeQuery({
                    query: Me,
                    data: { me: signIn.user }
                  });
                }}
              >
                {(signIn, { loading: authenticating }) =>
                  authenticating ? (
                    "..."
                  ) : (
                    <div className={cs.signIn}>
                      <form
                        onSubmit={event => {
                          event.preventDefault();
                          signIn({
                            variables: { email: input.current.value }
                          }).then(({ data: { signIn: { token } } }) => {
                            if (token) {
                              localStorage.setItem("mlToken", token);
                            }
                          });
                        }}
                      >
                        <input
                          ref={input}
                          type="email"
                          className={cs.input}
                          placeholder="your email"
                        />
                        <input
                          type="submit"
                          className={cs.button}
                          value="Sign In"
                        />
                      </form>
                    </div>
                  )
                }
              </Mutation>
            );
          }

          const { fullName } = data.me;
          return (
            <div style={{ width: '100%' }}>
              <div className={cs.info}>😈 {fullName}</div>
              <Mutation
                mutation={SignMeOut}
                update={(cache, { data: { signOut } }) => {
                  cache.writeQuery({
                    query: Me,
                    data: { me: null }
                  });
                }}
              >
                {(signOut, { loading: authenticating }) =>
                  authenticating ? (
                    "..."
                  ) : (
                    <div className={cs.signOut}>
                      <form
                        onSubmit={event => {
                          signOut({
                            variables: { token: localStorage.getItem('mlToken') }
                          }).then(() => {
                            localStorage.removeItem("mlToken");
                          });
                          event.preventDefault();
                        }}
                      >
                        <input
                          type="submit"
                          className={cs.button}
                          value="Sign out"
                        />
                      </form>
                    </div>
                  )
                }
              </Mutation>
            </div>
          );
        }}
      </Query>
    </div>
  );
};

export default UserInfo;
