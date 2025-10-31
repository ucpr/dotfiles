FROM denoland/deno:2.5.6

WORKDIR config

COPY . .

CMD ["bash"]
