## SUMMARY
- **Issue #3024:** [Prefix federation ID to e-cash notes when spending/reissuing/validating](https://github.com/fedimint/fedimint/pull/3024)

### GPT SUMMARY:
The text discusses the creation of a new struct called `OOBNotes` that includes the federation ID and notes. It mentions the need to inject the federation ID as modules are not aware of it. There is a suggestion to squash certain commits and make changes to the module API. The text also includes a discussion about addressing feedback, encountering an error during testing, and debugging the code. There is a mention of using hex encoding and considering a helper crate for serialization and deserialization. The discussion concludes with appreciation for the guidance and enjoyment in working on the enhancement.

## DETAILS
### Description:
We create a new struct called `OOBNotes` that encapsulates the federation ID + notes. Modules aren't aware of the federation ID so we also have to inject that.

Should close #2783 

### Comments:
- **elsirion:** Also I forgot to mention: you can squash the first two and the last two commits. That way there is one changing the module API and one making use of it. Currently it's a bit too granular/the commits only make sense in each others context.
- **shaurya947:** Thanks for the quick review @elsirion ! I will push more changes later today to address all the feedback :slightly_smiling_face: 
- **shaurya947:** I think I've addressed all the feedback in the latest push. `rust-tests` passes  but `load-test-tool-test` fails with this error:

![image](https://github.com/fedimint/fedimint/assets/3454081/ed356149-11cc-4dd1-a27e-217137e37132)

To debug, I modified the below code to print the note:

![image](https://github.com/fedimint/fedimint/assets/3454081/5c04a485-f63a-4215-9d5a-3442eee5f67a)

I can see the notes being printed:

![image](https://github.com/fedimint/fedimint/assets/3454081/eb9b5a76-54ef-440d-83f1-72efbb542e11)

I tried the value in an online validator and indeed it's not padded (even though it's valid). I may be missing something small but how do I ensure that the encoding is padded as necessary?
- **shaurya947:** I wonder if I'm doing this wrong by using `serde_as_encodable_hex` because that's hexifying the bytes after encoding them, and that's not the kind of string input we expect for `OOBNotes`. Going to try with custom ser/de impl to verify.
- **shaurya947:** > I wonder if I'm doing this wrong by using `serde_as_encodable_hex` because that's hexifying the bytes after encoding them, and that's not the kind of string input we expect for `OOBNotes`. Going to try with custom ser/de impl to verify.

Ok, yes, that was it. I feel silly, hah! Should be all good now—I added a custom ser/de impl.

On second thought I suppose we _could_ use hex (and change the `FromStr` impl to account for it). Let me know if that's preferable and I can change it back.

Edit: there's this [helper crate](https://docs.rs/serde_with/latest/serde_with/derive.DeserializeFromStr.html) as well for a derive macro to add ser/de impls using `FromStr` and `Display` that could be considered.
- **elsirion:** Hex encoding would be significantly longer, that's why I chose base64 in the first place.
- **dpc:** Could have made `serde_as_encodable_base64` macro. :D
- **shaurya947:** Thanks for the guidance folks, I enjoyed working on this enhancement :raised_hands: 

