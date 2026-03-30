FROM denoland/deno:2.7.9

WORKDIR config

COPY . .

CMD ["bash"]
