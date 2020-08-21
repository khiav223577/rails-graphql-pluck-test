import React from "react";
import { Mutation } from "react-apollo";
import { UpdateItemMutation, DestroyItemMutation } from "./operations.graphql";
import ProcessItemForm from "../ProcessItemForm";
import cs from "./styles";
import { LibraryQuery } from '../Library/operations.graphql';

const UpdateItemForm = ({
                          id,
                          initialTitle,
                          initialDescription,
                          initialImageUrl,
                          onClose
                        }) => (
  <div className={cs.overlay}>
    <div className={cs.content}>
      <Mutation mutation={UpdateItemMutation}>
        {(updateItem, { loading }) => (
          <ProcessItemForm
            initialImageUrl={initialImageUrl}
            initialTitle={initialTitle}
            initialDescription={initialDescription}
            buttonText="Update Item"
            loading={loading}
            onProcessItem={({ title, description, imageUrl }) => {
              updateItem({
                variables: {
                  id,
                  title,
                  description,
                  imageUrl
                },
                optimisticResponse: {
                  __typename: "Mutation",
                  updateItem: {
                    __typename: "UpdateItemMutationPayload",
                    item: {
                      id,
                      __typename: "Item",
                      title,
                      description,
                      imageUrl
                    }
                  }
                }
              });
              onClose();
            }}
          />
        )}
      </Mutation>
      <Mutation mutation={DestroyItemMutation}>
        {(destroyItem, { loading }) => (
          <button
            onClick={() => {
              destroyItem({
                variables: {
                  id,
                },
                update: (cache, { data: { destroyItem } }) => {
                  const currentItems = cache.readQuery({ query: LibraryQuery });
                  cache.writeQuery({
                    query: LibraryQuery,
                    data: {
                      items: currentItems.items.filter(item => item.id !== id),
                    },
                  });
                },
              });
              onClose();
            }}
            className={cs.button}
          >
            Destroy
          </button>
        )}
      </Mutation>
      <button className={cs.close} onClick={onClose}>
        Close
      </button>
    </div>
  </div>
);

export default UpdateItemForm;
